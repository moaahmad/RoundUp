//
//  AppEnvironment.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import Foundation

final class AppEnvironment {
    static let current = AppEnvironment()

    private let infoDictionary: [String: Any]
    private let configuration: [String: Any]

    private init() {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Cannot load Info.plist from App")
        }
        self.infoDictionary = infoDictionary

        guard let configuration = infoDictionary["Configuration"] as? [String: Any] else {
            fatalError("Info.plist doesn't contain 'Configuration' as [String: Any]")
        }
        self.configuration = configuration
    }

    static func valueFromInfoDictionary(for key: String) -> String {
        guard let value = Self.current.infoDictionary[key] as? String else {
            fatalError("Unable to find \(key) in Info.plist")
        }
        return value
    }

    static func valueFromConfigurationDictionary(for key: String) -> String {
        guard let value = Self.current.configuration[key] as? String else {
            fatalError("Unable to find \(key) in environment configuration")
        }
        return value
    }
}

extension AppEnvironment {
    static var apiToken: String {
        valueFromConfigurationDictionary(for: "API Token")
    }
}
