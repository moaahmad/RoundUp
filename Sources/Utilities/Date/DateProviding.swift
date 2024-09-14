//
//  DateProviding.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 14/09/2024.
//

import Foundation

protocol DateProviding {
    func currentWeekDateRange() -> (startOfWeek: Date, endOfWeek: Date)?
}
