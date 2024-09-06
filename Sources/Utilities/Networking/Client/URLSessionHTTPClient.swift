//
//  URLSessionHTTPClient.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private struct UnexpectedValuesRepresentation: Error {}

    // MARK: - Properties

    private let session: URLSession

    // MARK: - Initializer

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // MARK: - HTTPClient Functions

    func performRequest(
        _ request: URLRequest,
        completion: @escaping (HTTPClient.Result) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            completion(
                Result {
                    if let error = error {
                        throw error
                    } else if let data = data, let response = response as? HTTPURLResponse {
                        return (data, response)
                    } else {
                        throw UnexpectedValuesRepresentation()
                    }
                }
            )
        }.resume()
    }
}
