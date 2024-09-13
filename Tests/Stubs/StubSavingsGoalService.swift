//
//  StubSavingsGoalService.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 13/09/2024.
//

import Foundation
import Combine
@testable import StarlingRoundUp

final class StubSavingsGoalService: SavingsGoalsServicing {
    var allSavingsGoalsResult: Result<SavingsGoalsResponse, Error>?
    var fetchAllSavingGoalsCalls: [SavingsGoalsResponse] = []

    init(
        allSavingsGoalsResult: Result<SavingsGoalsResponse, Error>? = .success(MockData.anySavingsGoalResponse())
    ) {
        self.allSavingsGoalsResult = allSavingsGoalsResult
    }

    func fetchAllSavingGoals(
        for accountUid: String
    ) -> Future<SavingsGoalsResponse, Error> {
        Future<SavingsGoalsResponse, Error> { [weak self] promise in
            guard let result = self?.allSavingsGoalsResult else { return }
            switch result {
            case .success(let response):
                self?.fetchAllSavingGoalsCalls.append(response)
                promise(.success(response))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }

    func createSavingsGoal(
        accountUid: String,
        savingsGoalRequest: SavingsGoalRequest
    ) -> Future<StarlingRoundUp.CreateOrUpdateSavingsGoalResponse, Error> {
        // TODO: - Finish implementing function
        fatalError("createSavingsGoal hasn't been stubbed")
    }

    func addMoneyToSavingsGoal(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String,
        topUpRequest: TopUpRequest
    ) -> Future<SavingsGoalTransferResponse, Error> {
        // TODO: - Finish implementing function
        fatalError("addMoneyToSavingsGoal hasn't been stubbed")
    }
}
