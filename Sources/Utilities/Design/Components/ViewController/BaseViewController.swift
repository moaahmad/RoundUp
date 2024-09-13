//
//  BaseViewController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import SnapKit
import UIKit

class BaseViewController: UIViewController {
    private var containerView: UIView!

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Loading States

extension BaseViewController {
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        let activityIndicator = UIActivityIndicatorView(style: .large)

        view.addSubview(containerView)
        containerView.addSubview(activityIndicator)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        activityIndicator.startAnimating()
    }

    func dismissLoadingView() {
        DispatchQueue.main.async { [weak self] in
            self?.containerView.removeFromSuperview()
            self?.containerView = nil
        }
    }
}

// MARK: - Error Alert

extension BaseViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "error".localized(),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "ok".localized(),
                style: .default,
                handler: nil
            )
        )
        present(alert, animated: true, completion: nil)
    }
}
