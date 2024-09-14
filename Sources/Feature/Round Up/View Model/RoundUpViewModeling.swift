//
//  RoundUpViewModeling.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Combine

protocol RoundUpViewModeling {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var selectedSavingsGoal: CurrentValueSubject<SavingsGoal?, Never> { get }
    var isSavingRoundUp: CurrentValueSubject<Bool, Never> { get }
    var savingsGoals: CurrentValueSubject<[SavingsGoal], Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }
    var roundedUpTitle: String { get }

    func fetchData()
    func saveRoundedUpTotal(completion: @escaping () -> Void)
    func selectSavingsGoal(at index: Int)
}
