//
//  SavingsGoalsServicing.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Combine

protocol SavingsGoalsServicing {
    func fetchAllSavingGoals(for accountUid: String) -> Future<SavingsGoalsResponse, Error>
    func createSavingsGoal(
        accountUid: String,
        savingsGoalRequest: SavingsGoalRequest
    ) -> Future<CreateOrUpdateSavingsGoalResponse, Error>
    func addMoneyToSavingsGoal(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String,
        topUpRequest: TopUpRequest
    ) -> Future<SavingsGoalTransferResponse, Error>
}
