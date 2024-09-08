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

enum TransactionDirection: String, Codable {
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
    let currency: Currency
    let createdAt: String
    let name: String
}

struct Balance: Decodable {
    let effectiveBalance: CurrencyAndAmount
}

struct CurrencyAndAmount: Decodable & Encodable {
    /// ISO-4217 3 character currency code
    let currency: Currency
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
        formatter.currencyCode = currency.rawValue
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
    private(set) var id: String
    var amount: CurrencyAndAmount?
    var direction: TransactionDirection?
    var reference: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decodeIfPresent(CurrencyAndAmount.self, forKey: .amount)
        direction = try container.decodeIfPresent(TransactionDirection.self, forKey: .direction)
        reference = try container.decodeIfPresent(String.self, forKey: .reference)
        id = UUID().uuidString
    }

    init(
        amount: CurrencyAndAmount? = nil,
        direction: TransactionDirection? = nil,
        reference: String? = nil
    ) {
        self.amount = amount
        self.direction = direction
        self.reference = reference
        self.id = UUID().uuidString
    }
}

extension FeedItem: Hashable & Equatable {
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.id == rhs.id
    }
}

private extension FeedItem {
    enum CodingKeys: String, CodingKey {
        case amount
        case direction
        case reference
    }
}
