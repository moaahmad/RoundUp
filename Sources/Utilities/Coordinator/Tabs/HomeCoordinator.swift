//
//  HomeCoordinator.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class HomeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var rootController: UIViewController?

    init(navigationController: UINavigationController) {
        self.rootController = navigationController
    }

    func start() {
        let viewController = HomeViewController(viewModel: HomeViewModel(coordinator: self))
        navigationController?.pushViewController(viewController, animated: true)
    }

    func presentRoundedUpViewController(roundedUpTotal: CurrencyAndAmount) {
        let vc = RoundUpViewController(
            viewModel: RoundUpViewModel(
                roundedUpTotal: roundedUpTotal
            )
        )
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.large(), .medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        navigationController?.present(vc, animated: true)
    }
}
