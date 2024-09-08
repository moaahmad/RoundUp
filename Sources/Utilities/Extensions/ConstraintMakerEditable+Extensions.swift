//
//  ConstraintMakerEditable+Extensions.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import Foundation
import SnapKit

extension ConstraintMakerEditable {
    @discardableResult
    func padding(_ amount: CGFloat) -> ConstraintMakerEditable {
        offset(amount)
    }
}
