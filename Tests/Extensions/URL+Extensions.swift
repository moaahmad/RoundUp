//
//  URL+Extensions.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 12/09/2024.
//

import Foundation

extension URL {
    func getQueryItemValueForKey(key: String) -> String? {
        guard
            let components = NSURLComponents(url: self, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.filter {
            $0.name.lowercased() == key.lowercased()
        }.first?.value
    }
}
