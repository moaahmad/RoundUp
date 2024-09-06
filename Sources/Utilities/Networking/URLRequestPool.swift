//
//  URLRequestPool.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

protocol HomeURLRequestPooling {
    func userAccountsRequest() -> URLRequest
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

protocol SavingsURLRequestPooling {
    func allSavingsGoalsRequest(accountUid: String) -> URLRequest
    func createSavingsGoal(accountUid: String, savingsGoalRequestData: Data) -> URLRequest
}

protocol URLRequestPooling: HomeURLRequestPooling & SavingsURLRequestPooling {}

struct URLRequestPool: URLRequestPooling {
    func userAccountsRequest() -> URLRequest {
        .init(method: .get, url: URLPool.accountsURL())
    }

    func userNameRequest() -> URLRequest {
        .init(method: .get, url: URLPool.nameURL())
    }

    func accountHolderRequest() -> URLRequest {
        .init(method: .get, url: URLPool.accountHolderURL())
    }

    func userAccountIdentifiersRequest(accountUid: String) -> URLRequest {
        .init(
            method: .get,
            url: URLPool.accountIdentifiersURL(accountUid: accountUid)
        )
    }

    func accountBalanceRequest(accountUid: String) -> URLRequest {
        .init(
            method: .get,
            url: URLPool.balanceURL(accountUid: accountUid)
        )
    }

    func transactionFeedRequest(
        accountUid: String,
        categoryUid: String,
        changesSince: String
    ) -> URLRequest {
        .init(
            method: .get,
            url: URLPool.transactionsURL(
                accountUid: accountUid,
                categoryUid: categoryUid,
                changesSince: changesSince
            )
        )
    }

    // MARK: - SavingsURLRequestPooling

    func allSavingsGoalsRequest(accountUid: String) -> URLRequest {
        .init(
            method: .get,
            url: URLPool.allSavingsGoalsURL(accountUid: accountUid)
        )
    }

    func createSavingsGoal(
        accountUid: String,
        savingsGoalRequestData: Data
    ) -> URLRequest {
        var request = URLRequest(
            method: .put,
            url: URLPool.createSavingsGoalsURL(accountUid: accountUid)
        )
        request.httpBody = savingsGoalRequestData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
