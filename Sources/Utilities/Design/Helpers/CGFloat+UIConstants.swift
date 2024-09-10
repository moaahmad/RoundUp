//
//  UIConstants.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import UIKit

extension CGFloat {
    /// 0
    static let none: CGFloat = 0
    /// 2
    static let xxxs: CGFloat = 2
    /// 4
    static let xxs: CGFloat = 4
    /// 6
    static let xs: CGFloat = 6
    /// 8
    static let sm: CGFloat = 8
    /// 12
    static let md: CGFloat = 12
    /// 16
    static let base: CGFloat = 16
    /// 20
    static let lg: CGFloat = 20
    /// 24
    static let xl: CGFloat = 24
    /// 32
    static let xxl: CGFloat = 32
    /// 40
    static let xxxl: CGFloat = 40
}

extension CGFloat {
    static let buttonHeight: CGFloat = 50.0
    static let navigationBarHeight: CGFloat = 50.0
    static let textFieldHeight: CGFloat = 45
}

struct Device {
    static let width: CGFloat = UIScreen.main.bounds.width
    static let height: CGFloat = UIScreen.main.bounds.height

    private init() {}
}
