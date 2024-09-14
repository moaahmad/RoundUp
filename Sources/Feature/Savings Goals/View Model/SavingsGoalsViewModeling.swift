//
//  SavingsGoalsViewModeling.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Combine

protocol SavingsGoalsViewModeling {
    var title: String { get }
    var emptyState: (message: String, description: String) { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var savingsGoals: CurrentValueSubject<[SavingsGoal], Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }

    func fetchData()
    func didTapPlusButton()
}
