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
        let vc = HomeViewController(viewModel: HomeViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}
