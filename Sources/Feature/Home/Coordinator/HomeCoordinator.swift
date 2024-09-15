//
//  HomeCoordinator.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class HomeCoordinator: HomeCoordinating {
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
        let service = HomeService(client: client)
        let viewModel = HomeViewModel(service: service, coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        pushViewController(viewController: viewController, animated: true)
    }

    func presentRoundedUpViewController(
        balance: CurrencyAndAmount,
        transactions: [FeedItem]
    ) {
        let viewController = RoundUpViewController(
            viewModel: RoundUpViewModel(
                balance: balance,
                transactions: transactions,
                service: SavingsService(client: client)
            )
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        presentViewController(viewController: navigationController, animated: true)
    }
}
