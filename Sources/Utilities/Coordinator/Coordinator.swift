//
//  Coordinator.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var rootController: UIViewController? { get }
    var client: HTTPClient { get }

    func start()
}

// MARK: - Router Methods

extension Coordinator {
    var navigationController: UINavigationController? {
        rootController as? UINavigationController
    }

    func setRootViewController(
        viewController: UIViewController,
        hideBar: Bool = false,
        animated: Bool = true
    ) {
        navigationController?.setViewControllers([viewController], animated: animated)
        navigationController?.setNavigationBarHidden(hideBar, animated: animated)
    }

    func pushViewController(
        viewController: UIViewController,
        animated: Bool = true
    ) {
        navigationController?.pushViewController(
            viewController,
            animated: animated
        )
    }

    func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func presentViewController(
        viewController: UIViewController,
        animated: Bool = true
    ) {
        navigationController?.present(
            viewController,
            animated: animated,
            completion: nil
        )
    }

    func dismissViewController(animated: Bool = true) {
        navigationController?.dismiss(animated: animated, completion: nil)
    }
}
