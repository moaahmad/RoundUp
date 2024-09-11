//
//  AccountInfoView.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import SnapKit
import UIKit

final class AccountInfoView: UIView {
    // MARK: - UI Elements

    private lazy var nameLabel = STTitleLabel(
        font: .systemFont(ofSize: 18, weight: .semibold)
    )
    private lazy var accountNumberLabel = STValueView()
    private lazy var sortCodeLabel = STValueView()
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .black)
        label.textColor = .label
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [nameLabel, accountNumberLabel, sortCodeLabel, balanceLabel]
        )
        stackView.axis = .vertical
        stackView.spacing = .md
        stackView.distribution = .fillProportionally
        stackView.layoutMargins = .init(top: .base, left: .base, bottom: .base, right: .base)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        styleView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(name: String, accountNumber: String, sortCode: String, balance: String) {
        nameLabel.text = name
        accountNumberLabel.update(
            label: "account_number_label".localized(),
            value: accountNumber
        )
        sortCodeLabel.update(
            label: "sort_code_label".localized(),
            value: sortCode
        )
        balanceLabel.text = balance
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
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Previews

#Preview {
    let view = AccountInfoView()
    view.configure(
        name: "Denis Irwin",
        accountNumber: "1234567890",
        sortCode: "001122",
        balance: "£2340.23"
    )
    view.snp.makeConstraints { make in
        make.height.equalTo(Device.height * 0.2)
        make.width.equalTo(Device.width - .xxl)
    }
    return view
}
