//
//  Router.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import UIKit

final class Router: Routerable {
    enum NavigationMethod {
        case push, present, setAsRoot
    }

    private(set) var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func setRootViewController(
        viewController: UIViewController,
        animated: Bool = true
    ) {
        navigationController.setViewControllers([viewController], animated: animated)
    }

    func pushViewController(
        viewController: UIViewController,
        animated: Bool = true
    ) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }

    func presentViewController(
        viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)?
    ) {
        navigationController.present(
            viewController,
            animated: animated,
            completion: completion
        )
    }

    func dismissViewController(
        animated: Bool = true,
        completion: (() -> Void)?
    ) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    func navigateToViewController(
        _ viewController: UIViewController,
        withMethod navigationMethod: NavigationMethod,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        switch navigationMethod {
        case .push:
            pushViewController(viewController: viewController, animated: animated)
            guard let completion = completion else { return }
            completion()
        case .present:
            presentViewController(
                viewController: viewController,
                animated: animated,
                completion: completion
            )
        case .setAsRoot:
            setRootViewController(viewController: viewController, animated: animated)
            guard let completion = completion else { return }
            completion()
        }
    }
}
