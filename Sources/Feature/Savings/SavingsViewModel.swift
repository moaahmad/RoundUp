//
//  SavingsViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import Foundation

protocol SavingsViewModeling {
    var savingsGoals: CurrentValueSubject<[SavingsGoal], Never> { get }

    func fetchData()
    func didTapPlusButton()
}

final class SavingsViewModel: SavingsViewModeling {
    private let service: SavingsServicing
    let accountUid = "b74e212a-738b-426c-bbec-d17b6e406716" // REMOVE THIS!
    var savingsGoals = CurrentValueSubject<[SavingsGoal], Never>([])
    private var cancellables = Set<AnyCancellable>()

    init(service: SavingsServicing = SavingsService()) {
        self.service = service
    }

    func fetchData() {
        service.fetchAllSavingGoals(for: accountUid)
            .map(\.savingsGoalList)
            .catch { error -> AnyPublisher<[SavingsGoal], Never> in
                print(error.localizedDescription)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?.savingsGoals.send($0)
            }
            .store(in: &cancellables)
    }

    func didTapPlusButton() {
        print("Plus button tapped")
        service.createSavingsGoal(
            for: accountUid,
            with: SavingsGoalRequest(
                name: "Trip to London",
                currency: "GBP"
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
