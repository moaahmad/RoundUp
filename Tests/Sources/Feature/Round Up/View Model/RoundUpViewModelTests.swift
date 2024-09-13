//
//  RoundUpViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 13/09/2024.
//

import XCTest
@testable import StarlingRoundUp

// NOTE: - Due to time constraints only the round up calculation will be tested.

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
