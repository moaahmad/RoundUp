//
//  SavingsGoalsURLPooling.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

protocol SavingsGoalsURLPooling {
    func allSavingsGoalsURL(accountUid: String) -> URL
    func createSavingsGoalsURL(accountUid: String) -> URL
    func topUpSavingsGoalURL(accountUid: String, savingsGoalUid: String, transferUid: String) -> URL
}
