//
//  SavingsGoalsURLRequestPool.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

struct SavingsGoalsURLRequestPool: SavingsGoalsURLRequestPooling {
    private let urlPool: SavingsGoalsURLPooling

    init(urlPool: SavingsGoalsURLPooling = URLPool()) {
        self.urlPool = urlPool
    }

    func allSavingsGoalsRequest(accountUid: String) -> URLRequest {
        .init(
            method: .get,
            url: urlPool.allSavingsGoalsURL(accountUid: accountUid)
        )
    }

    func createSavingsGoal(
        accountUid: String,
        savingsGoalRequestData: Data
    ) -> URLRequest {
        .init(
            method: .put,
            url: urlPool.createSavingsGoalsURL(accountUid: accountUid),
            bodyData: savingsGoalRequestData
        )
    }

    func topUpSavingsGoal(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String,
        topUpRequestData: Data
    ) -> URLRequest {
        .init(
            method: .put,
            url: urlPool.topUpSavingsGoalURL(
                accountUid: accountUid,
                savingsGoalUid: savingsGoalUid,
                transferUid: transferUid
            ),
            bodyData: topUpRequestData
        )
    }
}
