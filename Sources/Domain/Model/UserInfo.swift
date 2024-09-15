//
//  UserInfo.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

struct UserInfo {
    private(set) var name: String
    private(set) var accountType: String
    private(set) var balance: CurrencyAndAmount
    private(set) var accountNumber: String
    private(set) var sortCode: String

    init(
        name: String = "",
        accountType: String = "",
        balance: CurrencyAndAmount = .init(currency: .gbp, minorUnits: 0),
        accountNumber: String = "",
        sortCode: String = ""
    ) {
        self.name = name
        self.accountType = accountType
        self.balance = balance
        self.accountNumber = accountNumber
        self.sortCode = sortCode
    }

    mutating func updateName(_ name: String) {
        self.name = name
    }

    mutating func updateBalance(_ currencyAndAmount: CurrencyAndAmount) {
        balance = currencyAndAmount
    }

    mutating func updateAccountType(_ type: AccountHolderType) {
        switch type {
        case .individual:
            accountType = "Individual"
        case .business:
            accountType = "Business"
        case .soleTrader:
            accountType = "Sole Trader"
        case .joint:
            accountType = "Joint"
        case .bankingAsAService:
            accountType = "Banking as a service"
        }
    }

    mutating func updateAccountIdentifiers(_ accountIdentifiers: AccountIdentifiers) {
        accountNumber = accountIdentifiers.accountIdentifier
        sortCode = accountIdentifiers.bankIdentifier
    }
}
