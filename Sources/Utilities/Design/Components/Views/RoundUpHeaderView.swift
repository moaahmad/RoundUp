//
//  RoundUpHeaderView.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 11/09/2024.
//

import SnapKit
import UIKit

final class RoundUpHeaderView: UIView {
    // MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "round_up_header_title".localized()
        title.textColor = .secondaryLabel
        title.font = .systemFont(ofSize: 16)
        return title
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, UIView()]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()


    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func configureLayout() {
        backgroundColor = .systemBackground
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(amount: .base)
            make.trailing.equalToSuperview().inset(amount: .base)
            make.bottom.equalToSuperview().inset(amount: .md)
        }
    }
}

// MARK: - Previews

#Preview {
    let view = RoundUpHeaderView()
    view.snp.makeConstraints { make in
        make.width.equalTo(Device.width)
        make.height.equalTo(Device.height)
    }
    return view
}
