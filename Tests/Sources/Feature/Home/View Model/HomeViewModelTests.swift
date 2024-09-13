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
    func test_viewCopyIsCorrect() {
        let sut = makeSUT()
        XCTAssertEqual(sut.title, "Home")
        XCTAssertEqual(sut.emptyState.message, "No Transactions")
        XCTAssertEqual(sut.emptyState.description, "You haven't completed any transactions yet.")
    }

    func test_isLoading_isFalseWhenDataIsFetched() {
        // Given
        var cancellables = Set<AnyCancellable>()
        let sut = makeSUT()
        awaitForCurrentAccount(sut)
        let exp = expectation(description: #function)

        XCTAssertTrue(sut.isLoading.value)

        sut.isLoading
            .drop(while: { $0 == true })
            .receive(on: DispatchQueue.main)
            .sink { _ in
                XCTAssertFalse(sut.isLoading.value)
                exp.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.fetchData()

        // Then
        wait(for: [exp], timeout: 1.0)
    }

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
                XCTAssertEqual(sut.feedItems.value.count, 3)
                XCTAssertEqual(firstItem.feedItemUid, "123")
                XCTAssertEqual(firstItem.amount, .init(currency: .gbp, minorUnits: 10000))
                XCTAssertEqual(firstItem.direction, .paymentOut)
                XCTAssertEqual(firstItem.reference, "Test Reference 1")
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
                XCTAssertEqual(firstItem.feedItemUid, "123")
                XCTAssertEqual(firstItem.amount, .init(currency: .gbp, minorUnits: 10000))
                XCTAssertEqual(firstItem.direction, .paymentOut)
                XCTAssertEqual(firstItem.reference, "Test Reference 1")
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

    func test_fetchData_returnsError() {
        // Given
        var cancellables = Set<AnyCancellable>()
        let service = StubHomeService(
            feedItemsResponseResult: .failure(APIError.invalidData)
        )
        let sut = makeSUT(service: service)
        awaitForCurrentAccount(sut)

        let exp = expectation(description: #function)

        sut.errorPublisher
            .sink {
                XCTAssertEqual($0.localizedDescription, "Invalid Data Error")
                exp.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.fetchData()

        // Then
        wait(for: [exp], timeout: 1.0)
    }

    func test_didTapRoundUp_coordinatorPresentRoundUpViewController() {
        // Given
        let coordinator = StubHomeCoordinator()
        let sut = makeSUT(coordinator: coordinator)

        // When
        sut.didTapRoundUp()

        // Then
        XCTAssertEqual(coordinator.presentRoundedUpViewControllerCallsCount, 1)
    }

    func test_didTapRoundUp_noCoordinatorSet_returnsEarly() {
        // Given
        let coordinator = StubHomeCoordinator()
        let sut = makeSUT(coordinator: nil)

        // When
        sut.didTapRoundUp()

        // Then
        XCTAssertEqual(coordinator.presentRoundedUpViewControllerCallsCount, 0)
    }

    func test_didChangeSegmentedControl_withIndex0_showsAllPayments() {
        // Given
        var cancellables = Set<AnyCancellable>()
        let sut = makeSUT()
        let exp = expectation(description: #function)

        awaitForData(sut)

        sut.filteredFeedItems
            .sink { items in
                XCTAssertEqual(items.count, 3)
                exp.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.didChangeSegmentedControl(index: 0)

        // Then
        wait(for: [exp], timeout: 1.0)
    }

    func test_didChangeSegmentedControl_withIndex1_showsPaymentsIn() {
        // Given
        var cancellables = Set<AnyCancellable>()
        let sut = makeSUT()
        let exp = expectation(description: #function)

        awaitForData(sut)

        sut.filteredFeedItems
            .sink { items in
                XCTAssertEqual(items.count, 1)
                XCTAssertTrue(
                    items.allSatisfy { $0.direction == .paymentIn }
                )
                exp.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.didChangeSegmentedControl(index: 1)

        // Then
        wait(for: [exp], timeout: 1.0)
    }

    func test_didChangeSegmentedControl_withIndex2_showsPaymentsOut() {
        // Given
        var cancellables = Set<AnyCancellable>()
        let sut = makeSUT()
        let exp = expectation(description: #function)

        awaitForData(sut)

        sut.filteredFeedItems
            .sink { items in
                XCTAssertEqual(items.count, 2)
                XCTAssertTrue(
                    items.allSatisfy { $0.direction == .paymentOut }
                )
                exp.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.didChangeSegmentedControl(index: 2)

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

    func awaitForData(_ sut: HomeViewModel) {
        var cancellables = Set<AnyCancellable>()
        let exp = expectation(description: #function)

        awaitForCurrentAccount(sut)

        sut.feedItems
            .drop(while: { $0.isEmpty })
            .receive(on: DispatchQueue.main)
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellables)

        sut.fetchData()

        wait(for: [exp], timeout: 1.0)
    }
}
