//
//  RootURLRequestPool.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

struct RootURLRequestPool: RootURLRequestPooling {
    private let urlPool: RootURLPooling

    init(urlPool: RootURLPooling = URLPool()) {
        self.urlPool = urlPool
    }

    func userAccountsRequest() -> URLRequest {
        .init(method: .get, url: urlPool.accountsURL())
    }
}
