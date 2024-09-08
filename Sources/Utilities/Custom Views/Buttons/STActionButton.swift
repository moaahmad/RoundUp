//
//  STActionButton.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 08/09/2024.
//

import UIKit

final class STActionButton: UIButton {
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.color = .white
        return spinner
    }()

    private var originalTitle: String = ""

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    convenience init(
        title: String,
        backgroundColor: UIColor = .accent
    ) {
        self.init(frame: .zero)
        self.originalTitle = title
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private func configure() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        layer.masksToBounds = true
        layer.cornerRadius = 12
        
        addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
