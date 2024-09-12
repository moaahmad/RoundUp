//
//  GenericAPIError.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 12/09/2024.
//

import Foundation

// NOTE: - I couldn't see this error model anywhere in the docs but came across it during testing
struct GenericAPIError: Decodable {
    let error: String
    let error_description: String
}
