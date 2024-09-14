//
//  HomeService.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import Foundation

struct HomeService: HomeServicing {
    // MARK: - Properties

    private let client: HTTPClient
    private let urlRequestPool: HomeURLRequestPooling
    private let decoder: JSONDecoder

    // MARK: - Initializer

    init(
        client: HTTPClient = URLSessionHTTPClient(),
        urlRequestPool: HomeURLRequestPooling = HomeURLRequestPool(),
        decoder: JSONDecoder = .init()
    ) {
        self.client = client
        self.urlRequestPool = urlRequestPool
        self.decoder = decoder
    }

    // MARK: - HomeFeedServicing Functions

    func fetchName() -> Future<UserName, Error> {
        client.fetchData(
            request: urlRequestPool.userNameRequest(),
            responseType: UserName.self,
            decoder: decoder
        )
    }

    func fetchAccountHolder() -> Future<AccountHolder, Error> {
        client.fetchData(
            request: urlRequestPool.accountHolderRequest(),
            responseType: AccountHolder.self,
            decoder: decoder
        )
    }

    func fetchAccountIdentifiers(accountUid: String) -> Future<AccountIdentifiers, Error> {
        client.fetchData(
            request: urlRequestPool.userAccountIdentifiersRequest(accountUid: accountUid),
            responseType: AccountIdentifiers.self,
            decoder: decoder
        )
    }

    func fetchBalance(accountUid: String) -> Future<Balance, Error> {
        client.fetchData(
            request: urlRequestPool.accountBalanceRequest(accountUid: accountUid),
            responseType: Balance.self,
            decoder: decoder
        )
    }

    func fetchTransactions(
        accountUid: String,
        categoryUid: String,
        changesSince: String
    ) -> Future<FeedItemsResponse, Error> {
        client.fetchData(
            request: urlRequestPool.transactionFeedRequest(
                accountUid: accountUid,
                categoryUid: categoryUid,
                changesSince: changesSince
            ),
            responseType: FeedItemsResponse.self,
            decoder: decoder
        )
    }
}
