//
//  HomeURLPooling.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

protocol HomeURLPooling {
    func accountHolderURL() -> URL
    func nameURL() -> URL
    func accountIdentifiersURL(accountUid: String) -> URL
    func balanceURL(accountUid: String) -> URL
    func transactionsURL(accountUid: String, categoryUid: String, changesSince: String) -> URL
}
