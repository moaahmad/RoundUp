//
//  Account.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

enum AccountType: String, Decodable {
    case primary = "PRIMARY"
    case additional = "ADDITIONAL"
    case load = "LOAN"
    case fixedTermDeposit = "FIXED_TERM_DEPOSIT"
}

enum TransactionDirection: String, Decodable {
    case paymentIn = "IN"
    case paymentOut = "OUT"
}

struct AccountsResponse: Decodable {
    let accounts: [Account]
}

struct Account: Decodable {
    let accountUid: String
    let accountType: AccountType
    let defaultCategory: String
    let currency: String
    let createdAt: String
    let name: String
}

struct Balance: Decodable {
    let effectiveBalance: CurrencyAndAmount
}

struct CurrencyAndAmount: Decodable {
    /// ISO-4217 3 character currency code
    let currency: String
    /// Amount in the minor units of the given currency (e.g., pence in GBP, cents in EUR)
    let minorUnits: Int64
}

extension CurrencyAndAmount: Hashable {}

extension CurrencyAndAmount {
    var formattedAmount: String? {
        // Convert the minor amount to the major amount (e.g., pence to pounds)
        let majorUnits = Double(minorUnits) / 100.0
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter.string(from: NSNumber(value: majorUnits))
    }
}

struct UserName: Decodable {
    let accountHolderName: String
}

struct AccountIdentifiers: Decodable {
    /// Identifier to uniquely identify the account at the bank
    let accountIdentifier: String
    /// Identifier to uniquely identify the bank
    let bankIdentifier: String
}

struct FeedItemsResponse: Decodable {
    let feedItems: [FeedItem]
}

struct FeedItem: Decodable {
    let amount: CurrencyAndAmount
    let direction: TransactionDirection
    let reference: String
}

extension FeedItem: Hashable {}
