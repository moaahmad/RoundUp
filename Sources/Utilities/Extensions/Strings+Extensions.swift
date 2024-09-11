//
//  Strings+Extensions.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

extension String {
    public func localized(_ parameters: [CVarArg] = []) -> String {
        let localizedString = NSLocalizedString(self, comment: "")
        return String(format: localizedString, arguments: parameters)
    }
}
