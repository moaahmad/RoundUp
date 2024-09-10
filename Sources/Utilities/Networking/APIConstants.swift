//
//  APIConstants.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Foundation

enum APIConstants {
    static var bearerToken: String {
        guard !AppEnvironment.apiToken.isEmpty else {
            fatalError("URL is not correctly configured - please ensure an API token is added to `Debug.xcconfig`")
        }
        return "Bearer \(AppEnvironment.apiToken)"
    }
}
