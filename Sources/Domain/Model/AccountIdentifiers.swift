//
//  AccountIdentifiers.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Foundation

struct AccountIdentifiers: Decodable {
    /// Identifier to uniquely identify the account at the bank
    let accountIdentifier: String
    /// Identifier to uniquely identify the bank
    let bankIdentifier: String
}
