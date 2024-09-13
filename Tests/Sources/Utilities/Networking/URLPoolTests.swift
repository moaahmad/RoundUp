//
//  URLPoolTests.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import XCTest
@testable import StarlingRoundUp

// NOTE: - Due to time constraints only `RootURLPooling` and `HomeURLPooling` functions will be tested.

final class URLPoolTests: XCTestCase {
    // MARK: - Root URLs

    func test_accountsURL_returnCorrectURL() {
        // Given
        let sut = URLPool()

        // When
        let url = sut.accountsURL()

        // Then
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(url.pathComponents, ["/", "api", "v2", "accounts"])
    }

    // MARK: - Home URLs

    func test_accountHolderURL_returnCorrectURL() {
        // Given
        let sut = URLPool()

        // When
        let url = sut.accountHolderURL()

        // Then
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(url.pathComponents, ["/", "api", "v2", "account-holder"])
    }

    func test_nameURL_returnCorrectURL() {
        // Given
        let sut = URLPool()

        // When
        let url = sut.nameURL()

        // Then
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(url.pathComponents, ["/", "api", "v2", "account-holder", "name"])
    }

    func test_accountIdentifiersURL_returnCorrectURL() {
        // Given
        let accountUid = UUID().uuidString
        let sut = URLPool()

        // When
        let url = sut.accountIdentifiersURL(accountUid: accountUid)

        // Then
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(
            url.pathComponents,
            ["/", "api", "v2", "accounts", accountUid, "identifiers"]
        )
    }

    func test_balanceURL_returnCorrectURL() {
        // Given
        let accountUid = UUID().uuidString
        let sut = URLPool()

        // When
        let url = sut.balanceURL(accountUid: accountUid)

        // Then
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(url.pathComponents, ["/", "api", "v2", "accounts", accountUid, "balance"])
    }

    func test_transactionsURL_returnCorrectURL() {
        // Given
        let accountUid = UUID().uuidString
        let categoryUid = UUID().uuidString
        let changesSince = Date.now.description
        let sut = URLPool()

        // When
        let url = sut.transactionsURL(
            accountUid: accountUid,
            categoryUid: categoryUid,
            changesSince: changesSince
        )

        // Then
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api-sandbox.starlingbank.com")
        XCTAssertEqual(
            url.pathComponents,
            ["/", "api", "v2", "feed", "account", accountUid, "category", categoryUid]
        )
        XCTAssertEqual(url.getQueryItemValueForKey(key: "changesSince"), changesSince)

    }
}
