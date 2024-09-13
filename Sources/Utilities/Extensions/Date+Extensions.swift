//
//  Date+Extensions.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 13/09/2024.
//

import Foundation

extension Date {
    /// Converts a `Date` object into an ISO 8601 formatted string.
    /// - Returns: A string in ISO 8601 format (e.g., "2024-09-13T16:18:44.660Z").
    var toISO8601String: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }

    /// Converts an ISO 8601 formatted string into a `Date` object.
    /// - Parameter iso8601String: The ISO 8601 formatted string to be converted.
    /// - Returns: A `Date` object if the string is valid, otherwise `nil`.
    static func fromISO8601String(_ iso8601String: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: iso8601String)
    }
}
