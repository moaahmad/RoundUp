//
//  HomeViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 07/09/2024.
//

import XCTest
@testable import StarlingRoundUp

extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance, "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}

final class HomeViewModelTests: XCTestCase {
    func test_calculateRoundedUpValue() {
        // Given
        let sut = makeSUT()
        awaitFeedItems(for: sut)

        // When
        sut.didTapRoundUp()

        // Then
        XCTAssertEqual(sut.roundedUpTotal, 1.58)
    }

}

// MARK: - Make SUT

extension HomeViewModelTests {
    func makeSUT(
        coordinator: Coordinator? = MockHomeCoordinator(),
        service: HomeServicing = MockHomeService(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> HomeViewModel {
        let sut = HomeViewModel(coordinator: coordinator, service: service)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

// MARK: - Helpers

extension HomeViewModelTests {
    func awaitFeedItems(for sut: HomeViewModel) {
        let exp = expectation(description: #function)
        var cancellables = Set<AnyCancellable>()

        sut.fetchData()

        sut.feedItems
            .sink { items in
                guard !items.isEmpty else { return }
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1.0)
    }
}

import Combine

final class MockHomeService: HomeServicing {

    private let mockAccountsResponse = AccountsResponse(accounts: [
        Account(
            accountUid: UUID().uuidString,
            accountType: .primary,
            defaultCategory: "default-category",
            currency: .gbp,
            createdAt: "2023-09-08T12:00:00Z",
            name: "Primary Account"
        ),
        Account(
            accountUid: UUID().uuidString,
            accountType: .additional,
            defaultCategory: "additional-category",
            currency: .gbp,
            createdAt: "2023-09-08T12:00:00Z",
            name: "Additional Account"
        )
    ])

    private let mockUserName = UserName(accountHolderName: "John Doe")

    private let mockAccountHolder = AccountHolder(accountHolderUid: UUID().uuidString, accountHolderType: .individual)

    private let mockAccountIdentifiers = AccountIdentifiers(
        accountIdentifier: UUID().uuidString,
        bankIdentifier: "001122"
    )

    private let mockBalance = Balance(effectiveBalance: CurrencyAndAmount(currency: .gbp, minorUnits: 10000))

    private let mockFeedItemsResponse = FeedItemsResponse(feedItems: [
        FeedItem(amount: CurrencyAndAmount(currency: .gbp, minorUnits: 435), direction: .paymentOut, reference: "General"),
        FeedItem(amount: CurrencyAndAmount(currency: .gbp, minorUnits: 87), direction: .paymentOut, reference: "Other"),
        FeedItem(amount: CurrencyAndAmount(currency: .gbp, minorUnits: 23), direction: .paymentIn, reference: "Other"),
        FeedItem(amount: CurrencyAndAmount(currency: .gbp, minorUnits: 520), direction: .paymentOut, reference: "Groceries")
    ])

    func fetchAccounts() -> Future<AccountsResponse, Error> {
        Future { promise in
            promise(.success(self.mockAccountsResponse))
        }
    }

    func fetchName() -> Future<UserName, Error> {
        Future { promise in
            promise(.success(self.mockUserName))
        }
    }

    func fetchAccountHolder() -> Future<AccountHolder, Error> {
        Future { promise in
            promise(.success(self.mockAccountHolder))
        }
    }

    func fetchAccountIdentifiers(accountUid: String) -> Future<AccountIdentifiers, Error> {
        Future { promise in
            promise(.success(self.mockAccountIdentifiers))
        }
    }

    func fetchBalance(accountUid: String) -> Future<Balance, Error> {
        Future { promise in
            promise(.success(self.mockBalance))
        }
    }

    func fetchTransactions(accountUid: String, categoryUid: String, changesSince: String) -> Future<FeedItemsResponse, Error> {
        Future { promise in
            promise(.success(self.mockFeedItemsResponse))
        }
    }
}

final class MockHomeCoordinator: Coordinator {
    var rootController: UIViewController?
    
    func start() {
        //
    }
}
