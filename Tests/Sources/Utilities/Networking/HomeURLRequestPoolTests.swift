//
//  HomeURLRequestPoolTests.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import XCTest
@testable import StarlingRoundUp

// NOTE: - Due to time constraints only `HomeURLRequestPool` functions will be tested.

final class HomeURLRequestPoolTests: XCTestCase {
    func test_accountHolderRequest_returnsCorrectURLRequest() {
        // Given
        let sut = HomeURLRequestPool()

        // When
        let request = sut.accountHolderRequest()

        // Then
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(request.url?.pathComponents, ["/", "api", "v2", "account-holder"])
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.timeoutInterval, 60.0)
    }

    func test_userNameRequest_returnsCorrectURLRequest() {
        // Given
        let sut = HomeURLRequestPool()

        // When
        let request = sut.userNameRequest()

        // Then
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(request.url?.pathComponents, ["/", "api", "v2", "account-holder", "name"])
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.timeoutInterval, 60.0)
    }

    func test_userAccountIdentifiersRequest_returnsCorrectURLRequest() {
        // Given
        let accountUid = UUID().uuidString
        let sut = HomeURLRequestPool()

        // When
        let request = sut.userAccountIdentifiersRequest(accountUid: accountUid)

        // Then
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(
            request.url?.pathComponents,
            ["/", "api", "v2", "accounts", accountUid, "identifiers"]
        )
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.timeoutInterval, 60.0)
    }

    func test_accountBalanceRequest_returnsCorrectURLRequest() {
        // Given
        let accountUid = UUID().uuidString
        let sut = HomeURLRequestPool()

        // When
        let request = sut.accountBalanceRequest(accountUid: accountUid)

        // Then
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(
            request.url?.pathComponents,
            ["/", "api", "v2", "accounts", accountUid, "balance"]
        )
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.timeoutInterval, 60.0)
    }

    func test_transactionFeedRequest_returnsCorrectURLRequest() {
        // Given
        let accountUid = UUID().uuidString
        let categoryUid = UUID().uuidString
        let changesSince = Date.now.toISO8601String
        let sut = HomeURLRequestPool()

        // When
        let request = sut.transactionFeedRequest(
            accountUid: accountUid,
            categoryUid: categoryUid,
            changesSince: changesSince
        )

        // Then
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(
            request.url?.pathComponents,
            ["/", "api", "v2", "feed", "account", accountUid, "category", categoryUid]
        )
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.timeoutInterval, 60.0)
    }
}
