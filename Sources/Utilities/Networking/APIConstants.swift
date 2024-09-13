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
            if !Environment.isRunningTests {
                fatalError("Please ensure an API token is added to `Debug.xcconfig`")
            }
            return ""
        }
        return "Bearer \(AppEnvironment.apiToken)"
    }
}
