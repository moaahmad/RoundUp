//
//  SavingsGoalCell.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 08/09/2024.
//

import SnapKit
import UIKit

final class SavingsGoalCell: UITableViewCell {
    static let reuseID = "SavingsGoalCell"

    // MARK: - UI Elements

    private lazy var titleLabel = STTitleLabel(title: "")
    private lazy var savedValueView = STValueView(label: "", value: "")
    private lazy var targetValueView = STValueView(label: "", value: "")

    private lazy var percentSavedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                savedValueView,
                targetValueView
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = .md
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [verticalStackView, percentSavedLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = .sm
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    func update(with savingsGoal: SavingsGoal, hidePercentSaved: Bool = false) {
        titleLabel.text = savingsGoal.name

        let totalSaved = savingsGoal.totalSaved.formattedString ?? "Nothing saved yet"
        savedValueView.update(label: "Saved so far:", value: totalSaved)

        let target = savingsGoal.target?.formattedString ?? "No target set"
        targetValueView.update(label: "Target:", value: target)

        if hidePercentSaved {
            percentSavedLabel.isHidden = true
        } else {
            let savedPercentage = savingsGoal.savedPercentage ?? 0
            percentSavedLabel.text = "\(savedPercentage)%"
        }
    }

    private func configureLayout() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(horizontalStackView)

        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
