//
//  RootService.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Combine
import Foundation

protocol RootServicing {
    func fetchAccounts() -> Future<AccountsResponse, Error>
}

struct RootService: RootServicing {
    // MARK: - Properties

    private let client: HTTPClient
    private let urlRequestPool: URLRequestPooling
    private let decoder: JSONDecoder

    // MARK: - Initializer

    init(
        client: HTTPClient = URLSessionHTTPClient(),
        urlRequestPool: URLRequestPooling = URLRequestPool(),
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
