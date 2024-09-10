//
//  CurrencyAndAmount.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Foundation

struct CurrencyAndAmount: Codable {
    /// ISO-4217 3 character currency code
    let currency: Currency
    /// Amount in the minor units of the given currency (e.g., pence in GBP or cents in EUR)
    let minorUnits: Int64
}

extension CurrencyAndAmount: Hashable {}

extension CurrencyAndAmount {
    var formattedString: String? {
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
