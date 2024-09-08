//
//  AppLaunchCoordinator.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class AppLaunchCoordinator: Coordinator {
    var rootController: UIViewController?
    var childCoordinators = [Coordinator]()
    var tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func start() {
        tabBarController.viewControllers = [
            createHomeNavigationController(),
            createSavingsNavigationController()
        ]
    }
}

// MARK: - Setup Home Controller

private extension AppLaunchCoordinator {
    func createHomeNavigationController() -> UINavigationController {
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        configureHomeCoordinator(with: homeNavigationController)
        return homeNavigationController
    }

    func configureHomeCoordinator(with navigationController: UINavigationController) {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
    }
}

// MARK: - Setup Savings Controller

private extension AppLaunchCoordinator {
    func createSavingsNavigationController() -> UINavigationController {
        let savingsNavigationController = UINavigationController()
        savingsNavigationController.navigationBar.prefersLargeTitles = true
        savingsNavigationController.tabBarItem = UITabBarItem(
            title: "Savings",
            image: UIImage(systemName: "banknote.fill"),
            tag: 1
        )
        configureSavingsCoordinator(with: savingsNavigationController)
        return savingsNavigationController
    }

    func configureSavingsCoordinator(with navigationController: UINavigationController) {
        let savingsCoordinator = SavingsCoordinator(navigationController: navigationController)
        savingsCoordinator.parentCoordinator = self
        savingsCoordinator.start()
        childCoordinators.append(savingsCoordinator)
    }
}
