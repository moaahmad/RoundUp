//
//  URLRequestPool.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

// MARK: - Root URL Requests

protocol RootURLRequestPooling {
    func userAccountsRequest() -> URLRequest
}

struct RootURLRequestPool: RootURLRequestPooling {
    private let urlPool: RootURLPooling

    init(urlPool: RootURLPooling = URLPool()) {
        self.urlPool = urlPool
    }

    func userAccountsRequest() -> URLRequest {
        .init(method: .get, url: urlPool.accountsURL())
    }
}

// MARK: - Home URL Requests

protocol HomeURLRequestPooling {
    func accountHolderRequest() -> URLRequest
    func userNameRequest() -> URLRequest
    func userAccountIdentifiersRequest(accountUid: String) -> URLRequest
    func accountBalanceRequest(accountUid: String) -> URLRequest
    func transactionFeedRequest(
        accountUid: String,
        categoryUid: String,
        changesSince: String
    ) -> URLRequest
}

struct HomeURLRequestPool: HomeURLRequestPooling {
    private let urlPool: HomeURLPooling

    init(urlPool: HomeURLPooling = URLPool()) {
        self.urlPool = urlPool
    }

    func userNameRequest() -> URLRequest {
        .init(method: .get, url: urlPool.nameURL())
    }

    func accountHolderRequest() -> URLRequest {
        .init(method: .get, url: urlPool.accountHolderURL())
    }

    func userAccountIdentifiersRequest(accountUid: String) -> URLRequest {
        .init(
            method: .get,
            url: urlPool.accountIdentifiersURL(accountUid: accountUid)
        )
    }

    func accountBalanceRequest(accountUid: String) -> URLRequest {
        .init(
            method: .get,
            url: urlPool.balanceURL(accountUid: accountUid)
        )
    }

    func transactionFeedRequest(
        accountUid: String,
        categoryUid: String,
        changesSince: String
    ) -> URLRequest {
        .init(
            method: .get,
            url: urlPool.transactionsURL(
                accountUid: accountUid,
                categoryUid: categoryUid,
                changesSince: changesSince
            )
        )
    }
}

// MARK: - Savings Goals URL Requests

protocol SavingsGoalsURLRequestPooling {
    func allSavingsGoalsRequest(accountUid: String) -> URLRequest
    func createSavingsGoal(accountUid: String, savingsGoalRequestData: Data) -> URLRequest
    func topUpSavingsGoal(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String,
        topUpRequestData: Data
    ) -> URLRequest
}

struct SavingsGoalsURLRequestPool: SavingsGoalsURLRequestPooling {
    private let urlPool: SavingsGoalsURLPooling

    init(urlPool: SavingsGoalsURLPooling = URLPool()) {
        self.urlPool = urlPool
    }

    func allSavingsGoalsRequest(accountUid: String) -> URLRequest {
        .init(
            method: .get,
            url: urlPool.allSavingsGoalsURL(accountUid: accountUid)
        )
    }

    func createSavingsGoal(
        accountUid: String,
        savingsGoalRequestData: Data
    ) -> URLRequest {
        .init(
            method: .put,
            url: urlPool.createSavingsGoalsURL(accountUid: accountUid),
            bodyData: savingsGoalRequestData
        )
    }

    func topUpSavingsGoal(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String,
        topUpRequestData: Data
    ) -> URLRequest {
        .init(
            method: .put,
            url: urlPool.topUpSavingsGoalURL(
                accountUid: accountUid,
                savingsGoalUid: savingsGoalUid,
                transferUid: transferUid
            ),
            bodyData: topUpRequestData
        )
    }
}
