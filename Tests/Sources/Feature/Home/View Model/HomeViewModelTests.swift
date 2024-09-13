//
//  HomeViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import Combine
import XCTest
@testable import StarlingRoundUp

final class HomeViewModelTests: XCTestCase {
    func test_fetchData_correctlyUpdatesFeedItems() {
        // Given
        var cancellables = Set<AnyCancellable>()
        let sut = makeSUT()
        awaitForCurrentAccount(sut)

        let exp = expectation(description: #function)

        sut.feedItems
            .drop(while: { $0.isEmpty })
            .receive(on: DispatchQueue.main)
            .sink { items in
                guard let firstItem = items.first else {
                    XCTFail("First item should not be nil")
                    return
                }
                XCTAssertEqual(sut.feedItems.value.count, 1)
                XCTAssertEqual(firstItem.feedItemUid, "1234")
                XCTAssertEqual(firstItem.amount, .init(currency: .gbp, minorUnits: 10000))
                XCTAssertEqual(firstItem.direction, .paymentOut)
                XCTAssertEqual(firstItem.reference, "Test Reference")
                exp.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.fetchData()

        // Then
        wait(for: [exp], timeout: 1.0)
    }

    func test_fetchData_correctlyUpdatesFilteredFeedItems() {
        // Given
        var cancellables = Set<AnyCancellable>()
        let sut = makeSUT()
        awaitForCurrentAccount(sut)

        let exp = expectation(description: #function)

        sut.filteredFeedItems
            .drop(while: { $0.isEmpty })
            .receive(on: DispatchQueue.main)
            .sink { items in
                guard let firstItem = items.first else {
                    XCTFail("First item should not be nil")
                    return
                }
                XCTAssertEqual(firstItem.feedItemUid, "1234")
                XCTAssertEqual(firstItem.amount, .init(currency: .gbp, minorUnits: 10000))
                XCTAssertEqual(firstItem.direction, .paymentOut)
                XCTAssertEqual(firstItem.reference, "Test Reference")
                exp.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.fetchData()

        // Then
        wait(for: [exp], timeout: 1.0)
    }

    func test_fetchData_correctlyUpdatesUserInfo() {
        // Given
        var cancellables = Set<AnyCancellable>()
        let sut = makeSUT()
        awaitForCurrentAccount(sut)

        let exp = expectation(description: #function)

        sut.userInfo
            .drop(while: {
                $0.accountNumber.isEmpty &&
                $0.sortCode.isEmpty &&
                $0.name.isEmpty &&
                $0.balance.isEmpty
            })
            .receive(on: DispatchQueue.main)
            .sink { userInfo in
                XCTAssertEqual(sut.userInfo.value.accountNumber, "account-identifier")
                XCTAssertEqual(sut.userInfo.value.sortCode, "001122")
                XCTAssertEqual(sut.userInfo.value.name, "Denis Irwin")
                XCTAssertEqual(sut.userInfo.value.balance, "£100.00")
                exp.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.fetchData()

        // Then
        wait(for: [exp], timeout: 1.0)
    }
}

// MARK: - Make SUT

private extension HomeViewModelTests {
    func makeSUT(
        service: HomeServicing = StubHomeService(),
        coordinator: HomeCoordinating? = StubHomeCoordinator(),
        appState: AppStateProviding = StubAppState(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> HomeViewModel {
        let sut = HomeViewModel(
            service: service,
            coordinator: coordinator,
            appState: appState
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

// MARK: - Helpers

private extension HomeViewModelTests {
    func awaitForCurrentAccount(_ sut: HomeViewModel) {
        var cancellables = Set<AnyCancellable>()
        let exp = expectation(description: #function)
        sut.$account
            .sink {
                guard $0 != nil else {
                    XCTFail("Account should not be nil")
                    return
                }
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1.0)
    }
}
