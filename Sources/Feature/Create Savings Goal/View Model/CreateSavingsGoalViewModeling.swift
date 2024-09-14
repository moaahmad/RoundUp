//
//  CreateSavingsGoalViewModeling.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Combine
import Foundation

protocol CreateSavingsGoalViewModeling {
    var title: String { get }
    var closeTitle: String { get }
    var errorMessage: String { get }
    var createGoalTitle: String { get }
    var nameTextPlaceholder: String { get }
    var selectCurrencyPlaceholder: String { get }
    var targetAmountPlaceholder: String { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }

    func shouldChangeCharacters(
        _ text: String?,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool
    func didTapCreateSavingsGoal(
        name: String,
        currency: String,
        target: String,
        completion: @escaping () -> Void
    )
}
