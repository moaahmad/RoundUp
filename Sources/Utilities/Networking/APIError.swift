//
//  APIError.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

public enum APIError: LocalizedError {
    case connectivity
    case invalidResponse
    case invalidRequest
    case invalidData

    public var errorDescription: String? {
        switch self {
        case .connectivity:
            "generic_error_title".localized()
        case .invalidData:
            "invalid_data_error_title".localized()
        case .invalidResponse:
            "invalid_response_error_title".localized()
        case .invalidRequest:
            "invalid_request_error_title".localized()
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .connectivity:
            "connectivity_error_message".localized()
        case .invalidData:
            "generic_error_message".localized()
        case .invalidResponse:
            "generic_error_message".localized()
        case .invalidRequest:
            "generic_error_message".localized()
        }
    }
}
