//
//  HomeCoordinatorTests.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 13/09/2024.
//

import XCTest
@testable import StarlingRoundUp

final class HomeCoordinatorTests: XCTestCase {
    func test_start_callsPushViewController() {
        // Given
        let navigationController = StubNavigationController()
        let sut = HomeCoordinator(
            client: HTTPClientSpy(),
            navigationController: navigationController
        )

        // When
        sut.start()

        // Then
        XCTAssertEqual(navigationController.pushViewControllerCalls.count, 1)
    }

    func test_presentRoundedUpViewController_callsPresent() {
        // Given
        let navigationController = StubNavigationController()
        let sut = HomeCoordinator(
            client: HTTPClientSpy(),
            navigationController: navigationController
        )

        // When
        sut.presentRoundedUpViewController(
            balance: .init(currency: .gbp, minorUnits: 1000), 
            transactions: MockData.anyFeedItemsResponse().feedItems
        )

        // Then
        XCTAssertEqual(navigationController.presentCalls.count, 1)
    }
}
