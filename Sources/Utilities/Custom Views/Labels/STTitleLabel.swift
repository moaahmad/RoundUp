//
//  STTitleLabel.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 08/09/2024.
//

import UIKit

final class STTitleLabel: UILabel {
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(
        title: String,
        textAlignment: NSTextAlignment = .left,
        color: UIColor = .label,
        font: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    ) {
        self.init(frame: .zero)
        self.text = title
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = color
    }

    // MARK: - UI Setup

    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        lineBreakMode = .byTruncatingTail
    }
}

// MARK: - Previews

#Preview {
    STTitleLabel(title: "Test Title")
}
