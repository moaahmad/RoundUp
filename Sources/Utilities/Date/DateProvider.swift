//
//  DateProvider.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 11/09/2024.
//

import Foundation

struct DateProvider: DateProviding {
    func currentWeekDateRange() -> (startOfWeek: Date, endOfWeek: Date)? {
        let calendar = Calendar.current
        let today = Date()

        guard
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start,
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek),
            let endOfWeekWithTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfWeek)
        else {
            return nil
        }

        return (startOfWeek, endOfWeekWithTime)
    }
}
