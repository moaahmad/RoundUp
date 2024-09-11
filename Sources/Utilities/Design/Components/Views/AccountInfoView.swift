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
        font: .systemFont(ofSize: 20, weight: .semibold)
    )
    private lazy var accountNumberLabel = STValueView()
    private lazy var sortCodeLabel = STValueView()
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .black)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        styleView()
        setupView()
        setupConstraints()
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
        addSubview(nameLabel)
        addSubview(accountNumberLabel)
        addSubview(sortCodeLabel)
        addSubview(balanceLabel)
    }

    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(amount: .lg)
            make.trailing.equalToSuperview().inset(amount: .lg)
        }

        accountNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(amount: .lg)
            make.leading.equalToSuperview().offset(amount: .lg)
            make.trailing.equalToSuperview().inset(amount: .lg)
        }

        sortCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(accountNumberLabel.snp_bottomMargin).offset(amount: .lg)
            make.leading.equalToSuperview().offset(amount: .lg)
            make.trailing.equalToSuperview().inset(amount: .lg)
        }

        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(sortCodeLabel.snp_bottomMargin).offset(amount: .lg)
            make.leading.equalToSuperview().offset(amount: .lg)
            make.trailing.equalToSuperview().inset(amount: .lg)
        }
    }

    // MARK: - Configuration

    func configure(name: String, accountNumber: String, sortCode: String, balance: String) {
        nameLabel.text = name
        accountNumberLabel.update(label: "Account Number: ", value: accountNumber)
        sortCodeLabel.update(label: "Sort Code:", value: sortCode)
        balanceLabel.text = balance
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
        make.height.equalTo(UIScreen.main.bounds.height * 0.2)
        make.width.equalTo(UIScreen.main.bounds.width - .xxl)
    }
    return view
}
