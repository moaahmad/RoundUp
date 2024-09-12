//
//  SavingsGoalsViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import Foundation

protocol SavingsGoalsViewModeling {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var savingsGoals: CurrentValueSubject<[SavingsGoal], Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }

    func fetchData()
    func didTapPlusButton()
}

final class SavingsGoalsViewModel: SavingsGoalsViewModeling {
    // MARK: - Properties

    private let service: SavingsGoalsServicing
    private let appState: AppStateProviding

    var isLoading = CurrentValueSubject<Bool, Never>(true)
    var savingsGoals = CurrentValueSubject<[SavingsGoal], Never>([])
    var errorPublisher = PassthroughSubject<Error, Never>()

    private var account: Account?
    private weak var coordinator: Coordinator?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(
        service: SavingsGoalsServicing,
        coordinator: Coordinator?,
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
        guard let coordinator = coordinator as? SavingsGoalsCoordinator else {
            return
        }
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
