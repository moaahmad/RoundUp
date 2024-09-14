//
//  HomeURLRequestPooling.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

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
