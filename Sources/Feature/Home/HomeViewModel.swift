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

    func fetchData()
}

final class HomeViewModel: HomeViewModeling {
    // MARK: - Properties

    private let service: HomeServicing

    var isLoading = CurrentValueSubject<Bool, Never>(true)
    var userInfo = CurrentValueSubject<UserInfo, Never>(.init())
    var feedItems = CurrentValueSubject<[FeedItem], Never>([])

    private var _userInfo = UserInfo()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(service: HomeServicing = HomeService()) {
        self.service = service
    }

    func fetchData() {
        let group = DispatchGroup()
        var account: Account?

        group.enter()
        service.fetchAccounts()
            .map(\.accounts)
            .compactMap { $0.first(where: { $0.accountType == .primary }) }
            .catch { error -> AnyPublisher<Account, Never> in
                print(error.localizedDescription)
                return Empty().eraseToAnyPublisher()
            }
            .sink { accountResponse in
                account = accountResponse
                group.leave()
            }
            .store(in: &cancellables)

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

        group.notify(queue: .global()) { [weak self] in
            guard let self,
                  let account else {
                return
            }

            fetchRemainingFeedData(account: account)
        }
    }
}

// MARK: - Fetch Data

private extension HomeViewModel {
    func fetchRemainingFeedData(account: Account) {
        let group = DispatchGroup()

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
        .catch { error -> AnyPublisher<[FeedItem], Never> in
            print(error.localizedDescription)
            return Empty().eraseToAnyPublisher()
        }
        .sink { [weak self] in
            self?.feedItems.send($0)
            group.leave()
        }
        .store(in: &cancellables)

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            isLoading.send(false)
            userInfo.send(_userInfo)
        }
    }
}
