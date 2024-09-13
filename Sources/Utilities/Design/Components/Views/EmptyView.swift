//
//  EmptyView.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 11/09/2024.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    // MARK: - UI Elements

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = .base
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layoutMargins = .init(top: .base, left: .base, bottom: .base, right: .base)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    // MARK: - Initializers

    convenience init(message: String, description: String) {
        self.init(frame: .zero)
        messageLabel.text = message
        descriptionLabel.text = description
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func styleView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = .lg
        layer.shadowOpacity = 0.15
        layer.shadowRadius = .xs
    }

    private func setupView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(amount: .base)
        }
    }
}
