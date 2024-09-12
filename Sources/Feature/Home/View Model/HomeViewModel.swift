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
    var feedItems: CurrentValueSubject<[FeedItem], Never> { get }
    var filteredFeedItems: PassthroughSubject<[FeedItem], Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }
    var isFeedEmpty: Bool { get }

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
    var feedItems = CurrentValueSubject<[FeedItem], Never>([])
    var filteredFeedItems = PassthroughSubject<[FeedItem], Never>()
    var errorPublisher = PassthroughSubject<Error, Never>()
    var roundedUpTotal: CurrencyAndAmount?
    var isFeedEmpty: Bool { feedItems.value.isEmpty }

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
            .catch { [weak self] error -> AnyPublisher<String, Never> in
                self?.errorPublisher.send(error)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?._userInfo.updateName($0)
                group.leave()
            }
            .store(in: &cancellables)

        group.enter()
        service.fetchAccountHolder()
            .catch { [weak self] error -> AnyPublisher<AccountHolder, Never> in
                self?.errorPublisher.send(error)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?._userInfo.updateAccountType($0.accountHolderType)
                group.leave()
            }
            .store(in: &cancellables)

        group.enter()
        service.fetchAccountIdentifiers(accountUid: account.accountUid)
            .catch { [weak self] error -> AnyPublisher<AccountIdentifiers, Never> in
                self?.errorPublisher.send(error)
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
            .catch { [weak self] error -> AnyPublisher<CurrencyAndAmount, Never> in
                self?.errorPublisher.send(error)
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
        .catch { [weak self] error -> AnyPublisher<[FeedItem], Never> in
            self?.errorPublisher.send(error)
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
        coordinator.presentRoundedUpViewController(
            transactions: feedItems.value
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
            .catch { [weak self] error -> AnyPublisher<Account?, Never> in
                self?.errorPublisher.send(error)
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
