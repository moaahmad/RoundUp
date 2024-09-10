//
//  Currency.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import Foundation

/// The list of currencies isn't complete!
enum Currency: String, Codable, CaseIterable {
    case gbp = "GBP"
    case eur = "EUR"
    case usd = "USD"
}
