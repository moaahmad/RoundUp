//
//  SavingsGoalsViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import Foundation

final class SavingsGoalsViewModel: SavingsGoalsViewModeling {
    // MARK: - Properties

    let title = "goals_tab_title".localized()
    let emptyState = (
        message: "savings_goals_empty_title".localized(),
        description: "savings_goals_empty_description".localized()
    )
    private let service: SavingsGoalsServicing
    private let appState: AppStateProviding

    var isLoading = CurrentValueSubject<Bool, Never>(true)
    var savingsGoals = CurrentValueSubject<[SavingsGoal], Never>([])
    var errorPublisher = PassthroughSubject<Error, Never>()

    private var account: Account?
    private weak var coordinator: SavingsGoalsCoordinating?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(
        service: SavingsGoalsServicing,
        coordinator: SavingsGoalsCoordinating?,
        appState: AppStateProviding = AppState.shared
    ) {
        self.coordinator = coordinator
        self.service = service
        self.appState = appState

        listenForCurrentAccount()
    }

    // MARK: - SavingsViewModeling Functions

    func fetchData() {
        guard let accountUid = account?.accountUid else { return }
        isLoading.send(true)
        service.fetchAllSavingGoals(for: accountUid)
            .map(\.savingsGoalList)
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> AnyPublisher<[SavingsGoal], Never> in
                self?.errorPublisher.send(error)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?.isLoading.send(false)
                self?.savingsGoals.send($0)
            }
            .store(in: &cancellables)
    }

    func didTapPlusButton() {
        guard let coordinator else { return }
        coordinator.presentCreateSavingsGoalVC(service: service)
    }
}

// MARK: - Listeners

private extension SavingsGoalsViewModel {
    func listenForCurrentAccount() {
        appState.currentAccount
            .catch { [weak self] error -> AnyPublisher<Account?, Never> in
                self?.errorPublisher.send(error)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?.account = $0
            }
            .store(in: &cancellables)
    }
}
