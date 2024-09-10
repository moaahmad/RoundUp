//
//  RootCoordinator.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class RootCoordinator: Coordinator {
    let client: HTTPClient
    let tabBarController: UITabBarController

    var rootController: UIViewController?
    var childCoordinators = [Coordinator]()

    init(
        client: HTTPClient,
        tabBarController: UITabBarController
    ) {
        self.client = client
        self.tabBarController = tabBarController
    }

    func start() {
        let service = RootService(client: client)
        let viewModel = RootViewModel(service: service, coordinator: self)
        let viewController = RootViewController(viewModel: viewModel)
        tabBarController.viewControllers = [viewController]
    }

    func navigateToAppTab() {
        let appTabCoordinator = AppTabCoordinator(
            client: client,
            tabBarController: tabBarController
        )
        appTabCoordinator.parentCoordinator = self
        appTabCoordinator.start()
        childCoordinators.append(appTabCoordinator)
        tabBarController.viewControllers = appTabCoordinator.tabBarController.viewControllers
    }
}
