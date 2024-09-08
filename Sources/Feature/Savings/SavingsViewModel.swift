//
//  SavingsViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import Foundation

protocol SavingsViewModeling {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var savingsGoals: CurrentValueSubject<[SavingsGoal], Never> { get }

    func fetchData()
    func didTapPlusButton()
}

final class SavingsViewModel: SavingsViewModeling {
    // MARK: - Properties

    private let service: SavingsServicing
    let accountUid = "b74e212a-738b-426c-bbec-d17b6e406716" // TODO: REMOVE THIS!
    
    var isLoading = CurrentValueSubject<Bool, Never>(true)
    var savingsGoals = CurrentValueSubject<[SavingsGoal], Never>([])

    private weak var coordinator: Coordinator?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(
        coordinator: Coordinator?,
        service: SavingsServicing = SavingsService()
    ) {
        self.coordinator = coordinator
        self.service = service
    }

    func fetchData() {
        isLoading.send(true)
        service.fetchAllSavingGoals(for: accountUid)
            .map(\.savingsGoalList)
            .catch { error -> AnyPublisher<[SavingsGoal], Never> in
                print(error.localizedDescription)
                return Empty().eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.isLoading.send(false)
                self?.savingsGoals.send($0)
            }
            .store(in: &cancellables)
    }

    func didTapPlusButton() {
        guard let coordinator = coordinator as? SavingsCoordinator else { return }
        coordinator.presentCreateSavingsGoalVC(service: service)
    }
}
