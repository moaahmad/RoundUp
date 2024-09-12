//
//  SavingsGoalsCoordinator.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class SavingsGoalsCoordinator: Coordinator {
    let client: HTTPClient
    var rootController: UIViewController?
    weak var parentCoordinator: Coordinator?

    init(
        client: HTTPClient,
        navigationController: UINavigationController
    ) {
        self.client = client
        self.rootController = navigationController
    }

    func start() {
        let service = SavingsService(client: client)
        let viewModel = SavingsGoalsViewModel(service: service, coordinator: self)
        let viewController = SavingsGoalsViewController(viewModel: viewModel)
        pushViewController(viewController: viewController, animated: true)
    }

    func presentCreateSavingsGoalVC(service: SavingsGoalsServicing) {
        let viewController = CreateSavingsGoalViewController(
            viewModel: CreateSavingsGoalViewModel(
                service: service
            )
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        presentViewController(viewController: navigationController, animated: true)
    }
}
