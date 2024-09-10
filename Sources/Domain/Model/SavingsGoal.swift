//
//  SavingsGoal.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

struct SavingsGoalsResponse: Decodable {
    let savingsGoalList: [SavingsGoal]
}

struct SavingsGoal: Decodable {
    ///  Unique identifier of the savings goal
    let savingsGoalUid: String
    let name: String
    let totalSaved: CurrencyAndAmount
    let state: SavingsGoalState

    ///  Percentage of target currently deposited in the savings goal
    var savedPercentage: Int?
    var target: CurrencyAndAmount?

    var isSelected: Bool?
}

extension SavingsGoal: Hashable {
    static func == (lhs: SavingsGoal, rhs: SavingsGoal) -> Bool {
        lhs.savingsGoalUid == rhs.savingsGoalUid &&
        lhs.isSelected == rhs.isSelected
    }
}

enum SavingsGoalState: String, Decodable {
    case creating = "CREATING"
    case active = "ACTIVE"
    case archiving = "ARCHIVING"
    case archived = "ARCHIVED"
    case restoring = "RESTORING"
    case pending = "PENDING"
}

struct SavingsGoalRequest: Encodable {
    let name: String
    let currency: Currency
    let target: CurrencyAndAmount
}

struct CreateOrUpdateSavingsGoalResponse: Decodable {
    let savingsGoalUid: String
    let success: Bool
}

struct TopUpRequest: Encodable {
    let amount: CurrencyAndAmount
}

struct SavingsGoalTransferResponse: Decodable {
    let transferUid: String
    let success: Bool
}
