//
//  CreateSavingsGoalViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Combine
import Foundation

final class CreateSavingsGoalViewModel: CreateSavingsGoalViewModeling {
    // MARK: - Properties

    let title = "create_savings_goal_title".localized()
    let closeTitle = "close".localized()
    let errorMessage = "Please fill in all fields"
    let createGoalTitle = "create_goal_button_title".localized()
    let nameTextPlaceholder = "enter_goal_name_placeholder".localized()
    let selectCurrencyPlaceholder = "select_currency_placeholder".localized()
    let targetAmountPlaceholder = "enter_target_amount_placeholder".localized()
    private let service: SavingsGoalsServicing
    private let appState: AppStateProviding

    var errorPublisher = PassthroughSubject<Error, Never>()
    private var account: Account?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(
        service: SavingsGoalsServicing,
        appState: AppStateProviding = AppState.shared
    ) {
        self.service = service
        self.appState = appState

        listenForCurrentAccount()
    }

    // MARK: - CreateSavingsGoalViewModeling Functions

    func shouldChangeCharacters(
        _ text: String?,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard
            let text,
            let stringRange = Range(range, in: text)
        else { return false }

        let updatedText = text.replacingCharacters(in: stringRange, with: string)

        // Check if the updated text has more than one decimal point
        if updatedText.components(separatedBy: ".").count - 1 > 1 {
            return false
        }

        // Limit to 2 decimal places if a decimal point exists
        if let decimalIndex = updatedText.firstIndex(of: ".") {
            let decimalPart = updatedText[decimalIndex...].dropFirst()
            if decimalPart.count > 2 {
                return false
            }
        }

        // Allow only numeric characters and a single decimal point
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }

        return true
    }

    func didTapCreateSavingsGoal(
        name: String,
        currency: String,
        target: String,
        completion: @escaping () -> Void
    ) {
        guard
            let accountUid = account?.accountUid,
            let currency = Currency(rawValue: currency),
            let minorUnits = Self.convertStringTargetToMinorUnits(target)
        else { return }

        service.createSavingsGoal(
            accountUid: accountUid,
            savingsGoalRequest: SavingsGoalRequest(
                name: name,
                currency: currency,
                target: CurrencyAndAmount(
                    currency: currency,
                    minorUnits: minorUnits
                )
            )
        )
        .receive(on: DispatchQueue.main)
        .catch { [weak self] error -> AnyPublisher<CreateOrUpdateSavingsGoalResponse, Never> in
            self?.errorPublisher.send(error)
            return Empty().eraseToAnyPublisher()
        }
        .sink { _ in
            completion()
        }
        .store(in: &cancellables)
    }
}

// MARK: - Listeners

private extension CreateSavingsGoalViewModel {
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

// MARK: - Private Helpers

private extension CreateSavingsGoalViewModel {
    static func convertStringTargetToMinorUnits(_ total: String) -> Int64? {
        guard let totalAsDouble = Double(total) else {
            return nil
        }
        return Int64(totalAsDouble * 100)
    }
}
