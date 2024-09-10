//
//  TransactionRowCell.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 09/09/2024.
//

import SnapKit
import UIKit

final class TransactionRowCell: UITableViewCell {
    static let reuseID = "TransactionRowCell"
    private var transactionDirection: TransactionDirection?

    // MARK: - UI Elements

    private lazy var titleLabel = STTitleLabel(
        title: "",
        font: .systemFont(ofSize: 16, weight: .regular)
    )

    private lazy var priceLabel = STTitleLabel(
        title: "",
        color: transactionDirection == .paymentIn ? .systemGreen : .label,
        font: .systemFont(ofSize: 18, weight: .medium)
    )

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, UIView(), priceLabel]
        )
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

    func update(with feedItem: FeedItem) {
        self.transactionDirection = feedItem.direction
        self.titleLabel.text = feedItem.reference ?? "Unknown Reference"
        let amount = feedItem.amount?.formattedString ?? "-"
        self.priceLabel.text = transactionDirection == .paymentIn ? "+\(amount)" : amount
        self.priceLabel.textColor = transactionDirection == .paymentIn ? .systemGreen : .label
    }

    private func configureLayout() {
        backgroundColor = .systemBackground
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: .base, left: .base, bottom: .base, right: .base)
            )
        }
    }
}
