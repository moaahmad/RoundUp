//
//  HomeCoordinator.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class HomeCoordinator: Coordinator {
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

    func presentRoundedUpViewController(roundedUpTotal: CurrencyAndAmount) {
        let viewController = RoundUpViewController(
            viewModel: RoundUpViewModel(
                roundedUpTotal: roundedUpTotal, 
                service: SavingsService(client: client)
            )
        )
        viewController.modalPresentationStyle = .pageSheet
        viewController.sheetPresentationController?.detents = [.large(), .medium()]
        viewController.sheetPresentationController?.prefersGrabberVisible = true
        presentViewController(viewController: viewController, animated: true)
    }
}
