//
//  SavingsCoordinator.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class SavingsCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var rootController: UIViewController?

    init(navigationController: UINavigationController) {
        self.rootController = navigationController
    }

    func start() {
        let vc = SavingsViewController(viewModel: SavingsViewModel(coordinator: self))
        navigationController?.pushViewController(vc, animated: true)
    }

    func presentCreateSavingsGoalVC(service: SavingsServicing) {
        let vc = CreateSavingsGoalViewController(
            viewModel: CreateSavingsGoalViewModel(
                service: service
            )
        )
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        navigationController?.present(vc, animated: true)
    }
}
