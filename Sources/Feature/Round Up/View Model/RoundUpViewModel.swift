//
//  RoundUpViewModel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import Combine
import Foundation

final class RoundUpViewModel: RoundUpViewModeling {
    // MARK: - Properties

    private let transactions: [FeedItem]
    private let service: SavingsGoalsServicing
    private let appState: AppStateProviding
    private let dateProvider: DateProviding

    var isLoading = CurrentValueSubject<Bool, Never>(true)
    var isSavingRoundUp = CurrentValueSubject<Bool, Never>(false)
    var selectedSavingsGoal = CurrentValueSubject<SavingsGoal?, Never>(nil)
    var savingsGoals = CurrentValueSubject<[SavingsGoal], Never>([])
    var errorPublisher = PassthroughSubject<Error, Never>()

    var roundedUpTitle: String {
        roundedUpTotal?.formattedString ?? "£0.00"
    }

    private(set) var roundedUpTotal: CurrencyAndAmount?
    private var account: Account?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    init(
        transactions: [FeedItem],
        service: SavingsGoalsServicing,
        appState: AppStateProviding = AppState.shared,
        dateProvider: DateProviding = DateProvider()
    ) {
        self.transactions = transactions
        self.service = service
        self.appState = appState
        self.dateProvider = dateProvider
        self.roundedUpTotal = calculateRoundUpTotal(for: transactions)

        listenForCurrentAccount()
        listenForSelectedSavingsGoal()
    }
}

// MARK: - RoundUpViewModeling Methods

extension RoundUpViewModel {
    func fetchData() {
        guard let accountUid = account?.accountUid else { return }
        service.fetchAllSavingGoals(for: accountUid)
            .map(\.savingsGoalList)
            .catch { [weak self] error -> AnyPublisher<[SavingsGoal], Never> in
                self?.errorPublisher.send(error)
                return Empty().eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] goals in
                self?.isLoading.send(false)
                self?.savingsGoals.send(goals)
            }
            .store(in: &cancellables)
    }

    func saveRoundedUpTotal(completion: @escaping () -> Void) {
        guard
            let accountUid = account?.accountUid,
            let savingsGoalUid = selectedSavingsGoal.value?.savingsGoalUid,
            let roundedUpTotal
        else { return }

        isSavingRoundUp.send(true)
        service.addMoneyToSavingsGoal(
            accountUid: accountUid,
            savingsGoalUid: savingsGoalUid,
            transferUid: UUID().uuidString,
            topUpRequest: .init(amount: roundedUpTotal)
        )
        .receive(on: DispatchQueue.main)
        .catch { [weak self] error -> AnyPublisher<SavingsGoalTransferResponse, Never> in
            self?.isSavingRoundUp.send(false)
            self?.errorPublisher.send(error)
            return Empty().eraseToAnyPublisher()
        }
        .sink { [weak self] _ in
            self?.isSavingRoundUp.send(false)
            completion()
        }
        .store(in: &cancellables)
    }

    func selectSavingsGoal(at index: Int) {
        var updatedSavingsGoals = savingsGoals.value
        updatedSavingsGoals = updatedSavingsGoals.enumerated().map { currentIndex, goal in
            var updatedGoal = goal
            updatedGoal.isSelected = (currentIndex == index)
            return updatedGoal
        }

        savingsGoals.send(updatedSavingsGoals)
    }
}

// MARK: - Listeners

private extension RoundUpViewModel {
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

    func listenForSelectedSavingsGoal() {
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

// MARK: - Private Helpers

private extension RoundUpViewModel {
    func calculateRoundUpTotal(for feedItems: [FeedItem]) -> CurrencyAndAmount {
        let transactions = filterFeedItemsStartedThisWeek(items: feedItems)
        guard !transactions.isEmpty else {
            return convertToCurrencyAndAmount(0)
        }
        let roundedUpTotal = feedItems
            .compactMap(\.amount?.minorUnits)
            .map(Self.calculateRoundedUpValue)
            .reduce(0, +)

        return convertToCurrencyAndAmount(roundedUpTotal)
    }

    func filterFeedItemsStartedThisWeek(items: [FeedItem]) -> [FeedItem] {
        guard let dateRange = dateProvider.currentWeekDateRange() else {
            return []
        }

        return items.filter { item in
            guard let startDate = item.transactionDate else { return false }
            return startDate >= dateRange.startOfWeek && startDate <= dateRange.endOfWeek
        }
    }

    func convertToCurrencyAndAmount(_ total: Double) -> CurrencyAndAmount {
        let currency = account?.currency ?? .gbp
        let minorUnits = Int64(total * 100)
        return CurrencyAndAmount(currency: currency, minorUnits: minorUnits)
    }

    static func calculateRoundedUpValue(_ minorUnit: Int64) -> Double {
        let majorUnit = Double(minorUnit) / 100.0
        let roundedUpValue = ceil(majorUnit)
        return roundedUpValue - majorUnit
    }
}
