//
//  AccountHolder.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

struct AccountHolder: Decodable {
    let accountHolderUid: String
    let accountHolderType: AccountHolderType
}

enum AccountHolderType: String, Decodable {
    case individual = "INDIVIDUAL"
    case business = "BUSINESS"
    case soleTrader = "SOLE_TRADER"
    case joint = "JOINT"
    case bankingAsAService = "BANKING_AS_A_SERVICE"
}
