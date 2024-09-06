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

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var accountNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var sortCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
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
        layer.cornerRadius = 20
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 6
    }

    private func setupView() {
        addSubview(nameLabel)
        addSubview(accountNumberLabel)
        addSubview(sortCodeLabel)
        addSubview(balanceLabel)
    }

    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        accountNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        sortCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(accountNumberLabel.snp_bottomMargin).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(sortCodeLabel.snp_bottomMargin).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    // MARK: - Configuration

    func configure(name: String, accountNumber: String, sortCode: String, balance: String) {
        nameLabel.text = name
        accountNumberLabel.text = "Account Number: \(accountNumber)"
        sortCodeLabel.text = "Sort Code: \(sortCode)"
        balanceLabel.text = balance
    }
}
