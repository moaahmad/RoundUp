//
//  HomeServiceTests.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import Combine
import XCTest
@testable import StarlingRoundUp

// NOTE: - Due to time constraints only `fetchName()` will be tested.

final class HomeServiceTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = .init()
    }

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
}

// MARK: - Fetch Name Tests

extension HomeServiceTests {
    // MARK: Failure Cases

    func test_fetchName_onSuccessWithNon200Code_returnsError() {
        // Given
        let (sut, client) = makeSUT()

        var returnedError: APIError?
        let exp = expectation(description: "Wait for fetch completion")

        // When
        sut.fetchName()
            .sink { completion in
                switch completion {
                case .failure(let error as APIError):
                    returnedError = error
                    exp.fulfill()
                default:
                    XCTFail("Expected fetch to fail with invalidResponse error")
                }
            } receiveValue: { _ in
                XCTFail("Expected fetch to fail with invalidResponse error")
            }
            .store(in: &cancellables)

        client.complete(withStatusCode: 100, data: .init())
        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertEqual(returnedError, .invalidResponse(nil))
    }

    func test_fetchName_onSuccessWithInvalidData_returnsError() {
        // Given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for fetch completion")
        var returnedError: APIError?

        // When
        sut.fetchName()
            .sink { completion in
                switch completion {
                case .failure(let error as APIError):
                    returnedError = error
                    exp.fulfill()
                default:
                    XCTFail("Expected fetch to fail with invalidData error")
                }
            } receiveValue: { _ in
                XCTFail("Expected fetch to fail with invalidData error")
            }
            .store(in: &cancellables)

        client.complete(withStatusCode: 200, data: MockServer.loadLocalJSON("BadJSON"))
        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertEqual(returnedError, .invalidData)
    }

    func test_fetchName_onFailure_returnsError() {
        // Given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for fetch completion")
        var returnedError: Error?

        // When
        sut.fetchName()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    returnedError = error
                    exp.fulfill()
                default:
                    XCTFail("Expected fetch to fail with invalidData error")
                }
            } receiveValue: { _ in
                XCTFail("Expected fetch to fail with error")
            }
            .store(in: &cancellables)

        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)

        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertNotNil(returnedError)
    }

    // MARK: - Success Cases

    func test_fetchRecipes_onSuccess_returnsRecipes() {
        // Given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for fetch completion")
        var returnedName: UserName?

        // When
        sut.fetchName()
            .sink { _ in } receiveValue: { userName in
                returnedName = userName
                exp.fulfill()
            }
            .store(in: &cancellables)


        let data = try! JSONEncoder().encode(UserName(accountHolderName: "Denis Irwin"))
        let expectedResponse = try! JSONDecoder().decode(UserName.self, from: data)
        client.complete(withStatusCode: 200, data: data)
        wait(for: [exp], timeout: 1.0)

        // Then
        XCTAssertEqual(returnedName, expectedResponse)
    }
}

// MARK: - Make SUT

private extension HomeServiceTests {
    func makeSUT() -> (sut: HomeService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = HomeService(client: client)
        return (sut, client)
    }
}
