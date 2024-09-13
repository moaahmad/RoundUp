//
//  HTTPClientSpy.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import Foundation
@testable import StarlingRoundUp

final class HTTPClientSpy: HTTPClient {
    // MARK: - Enums

    enum StatusCode: Int {
        case success = 200
        case error = 400
    }

    // MARK: - Properties

    private var messages = [(request: URLRequest, completion: (HTTPClient.Result) -> Void)]()

    var requests: [URLRequest] {
        return messages.map { $0.request }
    }

    // MARK: - Initializer

    init() {}

    // MARK: - Functions

    func performRequest(
        _ request: URLRequest,
        completion: @escaping (HTTPClient.Result) -> Void
    ) {
        messages.append((request, completion))
    }
}

extension HTTPClientSpy {
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }

    func complete(
        withStatusCode code: Int = StatusCode.success.rawValue,
        data: Data,
        at index: Int = 0
    ) {
        guard let url = requests[index].url else {
            assertionFailure("URL must not be nil")
            return
        }
        let response = HTTPURLResponse(
            url: url,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
}
