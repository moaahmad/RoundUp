//
//  STActionButton.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 08/09/2024.
//

import UIKit

final class STActionButton: UIButton {
    // MARK: - Properties

    private var originalTitle: String = ""

    // MARK: - UI Elements

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.color = .white
        return spinner
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        styleView()
    }

    convenience init(
        title: String,
        backgroundColor: UIColor = .accent
    ) {
        self.init(frame: .zero)
        originalTitle = title
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update Loading

    func showLoading(_ show: Bool) {
        if show {
            setTitle("", for: .normal)
            spinner.startAnimating()
            isEnabled = false
        } else {
            setTitle(originalTitle, for: .normal)
            spinner.stopAnimating()
            isEnabled = true
        }
    }
}

// MARK: - Setup Methods

private extension STActionButton {
    func setupView() {
       addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func styleView() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        layer.masksToBounds = true
        layer.cornerRadius = 12
    }
}
