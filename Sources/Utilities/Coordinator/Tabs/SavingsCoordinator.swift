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
        let vc = SavingsViewController(viewModel: SavingsViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}
