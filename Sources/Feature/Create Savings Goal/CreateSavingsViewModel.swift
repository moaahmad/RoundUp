//
//  CreateSavingsViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Combine

protocol CreateSavingsGoalViewModeling {
    func didTapCreateSavingsGoal(name: String, currency: String, target: String)
}

final class CreateSavingsGoalViewModel: CreateSavingsGoalViewModeling {
    // MARK: - Properties

    private let service: SavingsServicing
    let accountUid = "b74e212a-738b-426c-bbec-d17b6e406716" // TODO: REMOVE THIS!

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(service: SavingsServicing) {
        self.service = service
    }

    // MARK: - CreateSavingsGoalViewModeling Functions
    
    func didTapCreateSavingsGoal(name: String, currency: String, target: String) {
        guard
            let currency = Currency(rawValue: currency),
            let minorUnits = Int64(target)
        else { return }

        service.createSavingsGoal(
            accountUid: accountUid,
            savingsGoalRequest: SavingsGoalRequest(
                name: name,
                currency: currency,
                target: CurrencyAndAmount(currency: currency, minorUnits: minorUnits)
            )
        )
        .catch { error -> AnyPublisher<CreateOrUpdateSavingsGoalResponse, Never> in
            print(error.localizedDescription)
            return Empty().eraseToAnyPublisher()
        }
        .sink {
            print("Saving Goal ID: \($0.savingsGoalUid), success: \($0.success)")
        }
        .store(in: &cancellables)
    }
}
