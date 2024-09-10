//
//  HomeViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import Foundation

protocol HomeViewModeling {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var userInfo: CurrentValueSubject<UserInfo, Never> { get }
    var filteredFeedItems: PassthroughSubject<[FeedItem], Never> { get }

    func fetchData()
    func didTapRoundUp()
    func didChangeSegmentedControl(index: Int)
}

final class HomeViewModel: HomeViewModeling {
    // MARK: - Properties

    private let service: HomeServicing
    private let appState: AppStateProviding

    var isLoading = CurrentValueSubject<Bool, Never>(true)
    var userInfo = CurrentValueSubject<UserInfo, Never>(.init())
    var filteredFeedItems = PassthroughSubject<[FeedItem], Never>()
    var roundedUpTotal: CurrencyAndAmount?

    private var feedItems = CurrentValueSubject<[FeedItem], Never>([])
    private var account: Account?
    private var _userInfo = UserInfo()
    private var cancellables = Set<AnyCancellable>()
    private weak var coordinator: Coordinator?

    // MARK: - Initializer

    init(
        service: HomeServicing,
        coordinator: Coordinator?,
        appState: AppStateProviding = AppState.shared
    ) {
        self.service = service
        self.coordinator = coordinator
        self.appState = appState

        listenForCurrentAccount()
    }

    // MARK: - HomeViewModeling Functions
    
    func fetchData() {
        guard let account else { return }
        isLoading.send(true)
        let group = DispatchGroup()

        group.enter()
        service.fetchName()
            .map(\.accountHolderName)
            .catch { error -> AnyPublisher<String, Never> in
                print(error.localizedDescription)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?._userInfo.updateName($0)
                group.leave()
            }
            .store(in: &cancellables)

        group.enter()
        service.fetchAccountHolder()
            .catch { error -> AnyPublisher<AccountHolder, Never> in
                print(error.localizedDescription)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?._userInfo.updateAccountType($0.accountHolderType)
                group.leave()
            }
            .store(in: &cancellables)

        group.enter()
        service.fetchAccountIdentifiers(accountUid: account.accountUid)
            .catch { error -> AnyPublisher<AccountIdentifiers, Never> in
                print(error.localizedDescription)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?._userInfo.updateAccountIdentifiers($0)
                group.leave()
            }
            .store(in: &cancellables)

        group.enter()
        service.fetchBalance(accountUid: account.accountUid)
            .map(\.effectiveBalance)
            .catch { error -> AnyPublisher<CurrencyAndAmount, Never> in
                print(error.localizedDescription)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?._userInfo.updateBalance($0)
                group.leave()
            }
            .store(in: &cancellables)

        group.enter()
        service.fetchTransactions(
            accountUid: account.accountUid,
            categoryUid: account.defaultCategory,
            changesSince: account.createdAt
        )
        .map(\.feedItems)
        .removeDuplicates()
        .catch { error -> AnyPublisher<[FeedItem], Never> in
            print(error.localizedDescription)
            return Empty().eraseToAnyPublisher()
        }
        .sink { [weak self] in
            self?.feedItems.value = $0
            self?.filteredFeedItems.send($0)
            group.leave()
        }
        .store(in: &cancellables)

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            isLoading.send(false)
            userInfo.send(_userInfo)
        }
    }

    func didTapRoundUp() {
        guard let coordinator = coordinator as? HomeCoordinator else {
            return
        }
        
        let roundedUpTotal = feedItems.value
            .filter { $0.direction == .paymentOut }
            .compactMap(\.amount?.minorUnits)
            .map(Self.calculateRoundedUpValue)
            .reduce(0, +)

        coordinator.presentRoundedUpViewController(
            roundedUpTotal: convertToCurrencyAndAmount(
                roundedUpTotal
            )
        )
    }

    func didChangeSegmentedControl(index: Int) {
        updateFilteredItems(at: index)
    }
}

// MARK: - Listeners

private extension HomeViewModel {
    func listenForCurrentAccount() {
        appState.currentAccount
            .catch { error -> AnyPublisher<Account?, Never> in
                print(error.localizedDescription)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?.account = $0
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Helpers

private extension HomeViewModel {
    func convertToCurrencyAndAmount(_ total: Double) -> CurrencyAndAmount {
        let minorUnits = Int64(total * 100)
        return CurrencyAndAmount(currency: .gbp, minorUnits: minorUnits)
    }

    static func calculateRoundedUpValue(_ minorUnit: Int64) -> Double {
        // Convert the minor unit to a major unit
        let majorUnit = Double(minorUnit) / 100.0

        // Find the next value up from that major unit
        let roundedUpValue = ceil(majorUnit)

        // Calculate the difference and return it
        return roundedUpValue - majorUnit
    }

    func updateFilteredItems(at index: Int) {
        var items = feedItems.value
        switch index {
        case 1:
            items = items.filter { $0.direction == .paymentIn }
        case 2:
            items = items.filter { $0.direction == .paymentOut }
        default:
            break
        }
        return filteredFeedItems.send(items)
    }
}
