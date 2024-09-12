//
//  HTTPClient.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Combine
import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func performRequest(_ request: URLRequest, completion: @escaping (Result) -> Void)
}

// MARK: - Helpers

extension HTTPClient {
    func fetchData<T: Decodable>(
        request: URLRequest,
        responseType: T.Type,
        decoder: JSONDecoder
    ) -> Future<T, Error> {
        Future<T, Error> { promise in
            performRequest(request) { result in
                switch result {
                case let .success((data, response)):
                    handleFetchSuccessResponse(
                        data: data,
                        response: response,
                        decoder: decoder,
                        promise: promise
                    )
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }

    func handleFetchSuccessResponse<T: Decodable>(
        data: Data,
        response: HTTPURLResponse,
        decoder: JSONDecoder,
        promise: (Swift.Result<T, Error>) -> Void
    ) {
        do {
            switch response.statusCode {
            case 200...299:
                let decodedResponse = try decoder.decode(T.self, from: data)
                promise(.success(decodedResponse))
            case 403:
                let error = try decoder.decode(GenericAPIError.self, from: data)
                promise(.failure(APIError.invalidResponse(error.errorDescription)))
            default:
                let decodedErrorResponse = try decoder.decode(ErrorResponse.self, from: data)
                guard let error = decodedErrorResponse.errors.first else {
                    return promise(.failure(APIError.invalidResponse(nil)))
                }
                promise(.failure(APIError.invalidResponse(error.message)))
            }
        } catch {
            promise(.failure(APIError.invalidData))
        }
    }
}
