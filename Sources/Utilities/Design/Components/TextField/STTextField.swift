//
//  STTextField.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import SnapKit
import UIKit

final class STTextField: UITextField {
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)
        borderStyle = .roundedRect
        tintColor = .accent
        autocorrectionType = .no
    }

    convenience init(
        placeholder: String,
        keyboardType: UIKeyboardType = .default
    ) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
