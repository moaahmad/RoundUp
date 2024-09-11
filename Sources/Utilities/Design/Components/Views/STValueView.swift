//
//  STValueView.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 08/09/2024.
//

import SnapKit
import UIKit

final class STValueView: UIView {
    // MARK: - UI Elements

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var value: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, value, UIView(frame: .zero)])
        stackView.axis = .horizontal
        stackView.spacing = .xxs
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    func update(label: String, value: String) {
        self.label.text = label
        self.value.text = value
    }

    private func configureLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Previews

#Preview {
    let view = STValueView()
    view.update(label: "Label:", value: "Value")
    view.snp.makeConstraints { make in
        make.width.equalTo(UIScreen.main.bounds.width - .xxl)
    }
    return view
}
