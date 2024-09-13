//
//  StubHomeService.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import Foundation
import Combine
@testable import StarlingRoundUp

final class StubHomeService: HomeServicing {
    // MARK: - Properties

    var userNameResult: Result<UserName, Error>?
    var fetchNameCalls: [UserName] = []

    var accountHolderResult: Result<AccountHolder, Error>?
    var accountHolderCalls: [AccountHolder] = []

    var accountIdentifiersResult: Result<AccountIdentifiers, Error>?
    var accountIdentifiersCalls: [AccountIdentifiers] = []

    var balanceResult: Result<Balance, Error>?
    var balanceCalls: [Balance] = []

    var feedItemsResponseResult: Result<FeedItemsResponse, Error>?
    var feedItemsResponseCalls: [FeedItemsResponse] = []

    // MARK: - Initializer

    init(
        userNameResult: Result<UserName, Error>? = .success(MockData.anyUserName()),
        accountHolderResult: Result<AccountHolder, Error>? = .success(MockData.anyAccountHolder()),
        accountIdentifiersResult: Result<AccountIdentifiers, Error>? = .success(MockData.anyAccountIdentifiers()),
        balanceResult: Result<Balance, Error>? = .success(MockData.anyBalance()),
        feedItemsResponseResult: Result<FeedItemsResponse, Error>? = .success(MockData.anyFeedItemsResponse())
    ) {
        self.userNameResult = userNameResult
        self.accountHolderResult = accountHolderResult
        self.accountIdentifiersResult = accountIdentifiersResult
        self.balanceResult = balanceResult
        self.feedItemsResponseResult = feedItemsResponseResult
    }

    // MARK: - HomeServicing Functions

    func fetchName() -> Future<UserName, Error> {
        Future<UserName, Error> { [weak self] promise in
            guard let result = self?.userNameResult else { return }
            switch result {
            case .success(let response):
                self?.fetchNameCalls.append(response)
                promise(.success(response))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }

    func fetchAccountHolder() -> Future<AccountHolder, Error> {
        Future<AccountHolder, Error> { [weak self] promise in
            guard let result = self?.accountHolderResult else { return }
            switch result {
            case .success(let response):
                self?.accountHolderCalls.append(response)
                promise(.success(response))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }

    func fetchAccountIdentifiers(accountUid: String) -> Future<AccountIdentifiers, Error> {
        Future<AccountIdentifiers, Error> { [weak self] promise in
            guard let result = self?.accountIdentifiersResult else { return }
            switch result {
            case .success(let response):
                self?.accountIdentifiersCalls.append(response)
                promise(.success(response))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }

    func fetchBalance(accountUid: String) -> Future<Balance, Error> {
        Future<Balance, Error> { [weak self] promise in
            guard let result = self?.balanceResult else { return }
            switch result {
            case .success(let response):
                self?.balanceCalls.append(response)
                promise(.success(response))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }

    func fetchTransactions(
        accountUid: String,
        categoryUid: String,
        changesSince: String
    ) -> Future<FeedItemsResponse, Error> {
        Future<FeedItemsResponse, Error> { [weak self] promise in
            guard let result = self?.feedItemsResponseResult else { return }
            switch result {
            case .success(let response):
                self?.feedItemsResponseCalls.append(response)
                promise(.success(response))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
}
