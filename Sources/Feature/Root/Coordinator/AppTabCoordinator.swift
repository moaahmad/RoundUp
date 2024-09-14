//
//  AppTabCoordinator.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import UIKit

protocol AppTabCoordinating: Coordinator {}

final class AppTabCoordinator: AppTabCoordinating {
    let client: HTTPClient
    let tabBarController: UITabBarController

    var rootController: UIViewController?
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: Coordinator?

    init(
        client: HTTPClient,
        tabBarController: UITabBarController
    ) {
        self.client = client
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

private extension AppTabCoordinator {
    func createHomeNavigationController() -> UINavigationController {
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "home_tab_title".localized(),
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        configureHomeCoordinator(with: homeNavigationController)
        return homeNavigationController
    }

    func configureHomeCoordinator(with navigationController: UINavigationController) {
        let homeCoordinator = HomeCoordinator(
            client: client,
            navigationController: navigationController
        )
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
    }
}

// MARK: - Setup Savings Goals Controller

private extension AppTabCoordinator {
    func createSavingsNavigationController() -> UINavigationController {
        let savingsNavigationController = UINavigationController()
        savingsNavigationController.navigationBar.prefersLargeTitles = true
        savingsNavigationController.tabBarItem = UITabBarItem(
            title: "goals_tab_title".localized(),
            image: UIImage(systemName: "banknote.fill"),
            tag: 1
        )
        configureSavingsGoalsCoordinator(with: savingsNavigationController)
        return savingsNavigationController
    }

    func configureSavingsGoalsCoordinator(with navigationController: UINavigationController) {
        let savingsGoalsCoordinator = SavingsGoalsCoordinator(
            client: client,
            navigationController: navigationController
        )
        savingsGoalsCoordinator.parentCoordinator = self
        savingsGoalsCoordinator.start()
        childCoordinators.append(savingsGoalsCoordinator)
    }
}
