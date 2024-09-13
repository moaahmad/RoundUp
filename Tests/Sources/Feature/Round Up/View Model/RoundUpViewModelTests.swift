//
//  RoundUpViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 13/09/2024.
//

import XCTest
@testable import StarlingRoundUp

final class RoundUpViewModelTests: XCTestCase {
    func test_roundUp_isCalculatedCorrectly() {
        // Given
        let transactions: [FeedItem] = [
            .init(
                feedItemUid: "1",
                amount: .init(currency: .gbp, minorUnits: 435),
                transactionTime: Date.now.toISO8601String
            ),
            .init(
                feedItemUid: "2",
                amount: .init(currency: .gbp, minorUnits: 520),
                transactionTime: Date.now.toISO8601String
            ),
            .init(
                feedItemUid: "3",
                amount: .init(currency: .gbp, minorUnits: 87),
                transactionTime: Date.now.toISO8601String
            )
        ]
        let sut = makeSUT(transactions: transactions)

        // When
        let total = sut.roundedUpTotal

        // Then
        XCTAssertEqual(total?.currency, .gbp)
        XCTAssertEqual(total?.minorUnits, 158)
        XCTAssertEqual(total?.formattedString, "£1.58")
    }

    func test_roundUp_withEmptyTransactions_returnsZero() {
        // Given
        let transactions: [FeedItem] = []
        let sut = makeSUT(transactions: transactions)

        // When
        let total = sut.roundedUpTotal

        // Then
        XCTAssertEqual(total?.currency, .gbp)
        XCTAssertEqual(total?.minorUnits, 0)
        XCTAssertEqual(total?.formattedString, "£0.00")
    }

    func test_roundUp_withTransactionsOutsideCurrentWeek_returnsZero() {
        // Given
        let pastDate = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
        let transactions: [FeedItem] = [
            .init(
                feedItemUid: "1",
                amount: .init(currency: .gbp, minorUnits: 435),
                transactionTime: pastDate.toISO8601String
            ),
            .init(
                feedItemUid: "2",
                amount: .init(currency: .gbp, minorUnits: 520),
                transactionTime: pastDate.toISO8601String
            )
        ]
        let sut = makeSUT(transactions: transactions)

        // When
        let total = sut.roundedUpTotal

        // Then
        XCTAssertEqual(total?.currency, .gbp)
        XCTAssertEqual(total?.minorUnits, 0)
        XCTAssertEqual(total?.formattedString, "£0.00")
    }

    func test_roundUp_withExactWholeNumberTransactions_returnsZero() {
        // Given
        let transactions: [FeedItem] = [
            .init(
                feedItemUid: "1",
                amount: .init(currency: .gbp, minorUnits: 200),
                transactionTime: Date.now.toISO8601String
            ),
            .init(
                feedItemUid: "2",
                amount: .init(currency: .gbp, minorUnits: 100),
                transactionTime: Date.now.toISO8601String
            )
        ]
        let sut = makeSUT(transactions: transactions)

        // When
        let total = sut.roundedUpTotal

        // Then
        XCTAssertEqual(total?.currency, .gbp)
        XCTAssertEqual(total?.minorUnits, 0)
        XCTAssertEqual(total?.formattedString, "£0.00")
    }

    func test_roundUp_withMixedCurrencyTransactions_stillCalculatesCorrectly() {
        // Given
        let transactions: [FeedItem] = [
            .init(
                feedItemUid: "1",
                amount: .init(currency: .usd, minorUnits: 50),
                transactionTime: Date.now.toISO8601String
            ),
            .init(
                feedItemUid: "2",
                amount: .init(currency: .gbp, minorUnits: 550),
                transactionTime: Date.now.toISO8601String
            )
        ]
        let sut = makeSUT(transactions: transactions)

        // When
        let total = sut.roundedUpTotal

        // Then
        XCTAssertEqual(total?.currency, .gbp)
        XCTAssertEqual(total?.minorUnits, 100)
        XCTAssertEqual(total?.formattedString, "£1.00")
    }
}

// MARK: - Make SUT

private extension RoundUpViewModelTests {
    func makeSUT(
        transactions: [FeedItem] = MockData.anyFeedItemsResponse().feedItems,
        service: SavingsGoalsServicing = StubSavingsGoalService(),
        appState: AppStateProviding = StubAppState(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> RoundUpViewModel {
        let sut = RoundUpViewModel(
            transactions: transactions,
            service: service,
            appState: appState
        )

        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

import Combine

final class StubSavingsGoalService: SavingsGoalsServicing {
    var allSavingsGoalsResult: Result<SavingsGoalsResponse, Error>?
    var fetchAllSavingGoalsCalls: [SavingsGoalsResponse] = []

    init(
        allSavingsGoalsResult: Result<SavingsGoalsResponse, Error>? = .success(MockData.anySavingsGoalResponse())
    ) {
        self.allSavingsGoalsResult = allSavingsGoalsResult
    }

    func fetchAllSavingGoals(
        for accountUid: String
    ) -> Future<SavingsGoalsResponse, Error> {
        Future<SavingsGoalsResponse, Error> { [weak self] promise in
            guard let result = self?.allSavingsGoalsResult else { return }
            switch result {
            case .success(let response):
                self?.fetchAllSavingGoalsCalls.append(response)
                promise(.success(response))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }

    func createSavingsGoal(
        accountUid: String,
        savingsGoalRequest: SavingsGoalRequest
    ) -> Future<StarlingRoundUp.CreateOrUpdateSavingsGoalResponse, Error> {
        // TODO: - Finish implementing function
        fatalError("createSavingsGoal hasn't been stubbed")
    }

    func addMoneyToSavingsGoal(
        accountUid: String,
        savingsGoalUid: String,
        transferUid: String,
        topUpRequest: TopUpRequest
    ) -> Future<SavingsGoalTransferResponse, Error> {
        // TODO: - Finish implementing function
        fatalError("addMoneyToSavingsGoal hasn't been stubbed")
    }
}

extension MockData {
    static func anySavingsGoalResponse() -> SavingsGoalsResponse {
        .init(
            savingsGoalList: [
                .init(
                    savingsGoalUid: "123",
                    name: "Savings Goal 1",
                    totalSaved: .init(currency: .gbp, minorUnits: 10000),
                    state: .active
                )
            ]
        )
    }
}
