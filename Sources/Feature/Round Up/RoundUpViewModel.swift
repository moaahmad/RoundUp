//
//  RoundUpViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import Combine
import Foundation

protocol RoundUpViewModeling {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var selectedSavingsGoal: CurrentValueSubject<SavingsGoal?, Never> { get }
    var isSavingRoundUp: CurrentValueSubject<Bool, Never> { get }
    var savingsGoals: CurrentValueSubject<[SavingsGoal], Never> { get }
    var roundedUpTotal: CurrencyAndAmount { get }
    
    func fetchData()
    func saveRoundedUpTotal(completion: @escaping () -> Void)
    func selectSavingsGoal(at index: Int)
}

final class RoundUpViewModel: RoundUpViewModeling {
    // MARK: - Properties

    let roundedUpTotal: CurrencyAndAmount
    private let service: SavingsServicing

    let accountUid = "b74e212a-738b-426c-bbec-d17b6e406716" // TODO: REMOVE THIS!
    var isLoading = CurrentValueSubject<Bool, Never>(true)
    var isSavingRoundUp = CurrentValueSubject<Bool, Never>(false)
    var selectedSavingsGoal = CurrentValueSubject<SavingsGoal?, Never>(nil)
    var savingsGoals = CurrentValueSubject<[SavingsGoal], Never>([])

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    init(
        roundedUpTotal: CurrencyAndAmount,
        service: SavingsServicing = SavingsService()
    ) {
        self.roundedUpTotal = roundedUpTotal
        self.service = service

        savingsGoals
            .compactMap {
                $0.first(where: { $0.isSelected == true })
            }
            .removeDuplicates()
            .sink { [weak self] in
                self?.selectedSavingsGoal.send($0)
            }
            .store(in: &cancellables)
    }
}

// MARK: - RoundUpViewModeling Methods

extension RoundUpViewModel {
    func fetchData() {
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

    func saveRoundedUpTotal(completion: @escaping () -> Void) {
        guard let selectedSavingsGoal = selectedSavingsGoal.value else { return }
        isSavingRoundUp.send(true)
        service.addMoneyToSavingsGoal(
            accountUid: accountUid,
            savingsGoalUid: selectedSavingsGoal.savingsGoalUid,
            transferUid: UUID().uuidString,
            topUpRequest: .init(amount: roundedUpTotal)
        )
        .receive(on: DispatchQueue.main)
        .catch { error -> AnyPublisher<SavingsGoalTransferResponse, Never> in
            print(error.localizedDescription)
            return Empty().eraseToAnyPublisher()
        }
        .sink { [weak self] in
            print("Transfer ID: \($0.transferUid), success: \($0.success)")
            self?.isSavingRoundUp.send(false)
            completion()
        }
        .store(in: &cancellables)
    }

    func selectSavingsGoal(at index: Int) {
        var updatedSavingsGoals = savingsGoals.value
        updatedSavingsGoals = updatedSavingsGoals.enumerated().map {
            currentIndex, goal in
            var updatedGoal = goal
            updatedGoal.isSelected = (currentIndex == index)
            return updatedGoal
        }

        savingsGoals.send(updatedSavingsGoals)
    }
}
