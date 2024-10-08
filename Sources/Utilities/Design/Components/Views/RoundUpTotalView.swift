//
//  RoundUpTotalView.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 08/09/2024.
//

import SnapKit
import UIKit

final class RoundUpTotalView: UIView {
    // MARK: - UI Elements

    private lazy var subtitleLabel = STTitleLabel(
        title: "round_up_subtitle".localized(),
        color: .secondaryLabel,
        font: .systemFont(ofSize: 16, weight: .medium)
    )

    private lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 27, weight: .black)
        return valueLabel
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [valueLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = .xxxs
        stackView.alignment = .leading
        stackView.layoutMargins = UIEdgeInsets(top: .xl, left: .none, bottom: .md, right: .none)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    convenience init(total: String) {
        self.init(frame: .zero)
        valueLabel.text = String(total)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    func configureLayout() {
        addSubview(headerStackView)

        headerStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
