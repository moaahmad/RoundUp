//
//  MockServer.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import Foundation

final class MockServer {
    static func loadLocalJSON(_ fileName: String) -> Data {
        guard
            let path = Bundle(
                for: MockServer.self
            ).url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: path)
        else {
            return Data()
        }

        return data
    }
}
