//
//  HomeServicing.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Combine
import Foundation

protocol HomeServicing {
    func fetchName() -> Future<UserName, Error>
    func fetchAccountHolder() -> Future<AccountHolder, Error>
    func fetchAccountIdentifiers(accountUid: String) -> Future<AccountIdentifiers, Error>
    func fetchBalance(accountUid: String) -> Future<Balance, Error>
    func fetchTransactions(
        accountUid: String,
        categoryUid: String,
        changesSince: String
    ) -> Future<FeedItemsResponse, Error>
}
