//
//  SavingsGoalsURLRequestPooling.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

protocol SavingsGoalsURLRequestPooling {
    func allSavingsGoalsRequest(accountUid: String) -> URLRequest
    func createSavingsGoal(accountUid: String, savingsGoalRequestData: Data) -> URLRequest
    func topUpSavingsGoal(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String,
        topUpRequestData: Data
    ) -> URLRequest
}
