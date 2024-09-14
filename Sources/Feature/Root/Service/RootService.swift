//
//  RootService.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Combine
import Foundation

struct RootService: RootServicing {
    // MARK: - Properties

    private let client: HTTPClient
    private let urlRequestPool: RootURLRequestPooling
    private let decoder: JSONDecoder

    // MARK: - Initializer

    init(
        client: HTTPClient = URLSessionHTTPClient(),
        urlRequestPool: RootURLRequestPooling = RootURLRequestPool(),
        decoder: JSONDecoder = .init()
    ) {
        self.client = client
        self.urlRequestPool = urlRequestPool
        self.decoder = decoder
    }

    // MARK: - RootServicing Functions

    func fetchAccounts() -> Future<AccountsResponse, Error> {
        client.fetchData(
            request: urlRequestPool.userAccountsRequest(),
            responseType: AccountsResponse.self,
            decoder: decoder
        )
    }
}
