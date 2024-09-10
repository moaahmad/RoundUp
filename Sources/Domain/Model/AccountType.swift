//
//  AccountType.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Foundation

enum AccountType: String, Decodable {
    case primary = "PRIMARY"
    case additional = "ADDITIONAL"
    case load = "LOAN"
    case fixedTermDeposit = "FIXED_TERM_DEPOSIT"
}
