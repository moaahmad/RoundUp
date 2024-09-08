//
//  TransactionsHeaderView.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 08/09/2024.
//

import SnapKit
import UIKit

final class TransactionsHeaderView: UIView {
    // MARK: - UI Elements
    
    lazy var roundUpButton: UIButton = {
        let button = STActionButton(title: "Round Up")
        button.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.3)
        }
        return button
    }()

    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["All", "In", "Out"])
        control.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .accent
        control.backgroundColor = .systemBackground
        control.layoutMargins = .init(top: .none, left: .none, bottom: .base, right: .none)
        return control
    }()

    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Transactions"
        title.textColor = .label
        title.font = .systemFont(ofSize: .base, weight: .semibold)
        return title
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), roundUpButton])
        stackView.axis = .horizontal
        stackView.spacing = .md
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layoutMargins = .init(top: .md, left: .none, bottom: .none, right: .none)
        stackView.isLayoutMarginsRelativeArrangement = true
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
        addSubview(segmentedControl)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().padding(.base)
            make.trailing.equalToSuperview().padding(-.base)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).padding(.base)
            make.leading.equalToSuperview().padding(.base)
            make.trailing.equalToSuperview().padding(-.base)
            make.bottom.equalToSuperview().padding(-.md)
        }
    }
}

#Preview {
    let view = TransactionsHeaderView()
    view.snp.makeConstraints { make in
        make.width.equalTo(UIScreen.main.bounds.width)
    }
    return view
}
