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
    private let appState: AppStateProviding

    private var account: Account?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(
        service: SavingsServicing,
        appState: AppStateProviding = AppState.shared
    ) {
        self.service = service
        self.appState = appState

        listenForCurrentAccount()
    }

    // MARK: - CreateSavingsGoalViewModeling Functions
    
    func didTapCreateSavingsGoal(name: String, currency: String, target: String) {
        guard
            let accountUid = account?.accountUid,
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

// MARK: - Listeners

private extension CreateSavingsGoalViewModel {
    func listenForCurrentAccount() {
        appState.currentAccount
            .catch { error -> AnyPublisher<Account?, Never> in
                print(error.localizedDescription)
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] in
                self?.account = $0
            }
            .store(in: &cancellables)
    }
}
