//
//  ErrorResponse.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 11/09/2024.
//

import Foundation

struct ErrorResponse: Decodable {
    let errors: [ErrorDetail]
    let success: Bool
}

struct ErrorDetail: Decodable {
    let message: String
}
