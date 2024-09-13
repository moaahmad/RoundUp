//
//  Environment.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 13/09/2024.
//

import Foundation

struct Environment {
    static var isRunningTests: Bool {
        UserDefaults.standard.value(forKey: "XCTIDEConnectionTimeout") != nil
    }
}
