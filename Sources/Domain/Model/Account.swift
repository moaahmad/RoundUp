//
//  Account.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

struct AccountsResponse: Decodable {
    let accounts: [Account]
}

struct Account: Decodable {
    let accountUid: String
    let accountType: AccountType
    let defaultCategory: String
    let currency: Currency
    let createdAt: String
    let name: String
}
