//
//  StubNavigationController.swift
//  StarlingRoundUpTests
//
//  Created by Mo Ahmad on 13/09/2024.
//

import UIKit

final class StubNavigationController: UINavigationController {
    var pushViewControllerCalls: [UIViewController] = []
    var presentCalls: [UIViewController] = []

    override func pushViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        pushViewControllerCalls.append(viewController)
    }

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        presentCalls.append(viewControllerToPresent)
    }
}
