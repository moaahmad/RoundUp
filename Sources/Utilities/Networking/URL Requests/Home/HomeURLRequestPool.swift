//
//  HomeURLRequestPool.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

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
