//
//  STTabBarController.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 10/09/2024.
//

import UIKit

final class STTabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBar.itemPositioning = .centered
        tabBar.items?.forEach {
            $0.imageInsets = UIEdgeInsets(
                top: .xs,
                left: .none,
                bottom: -.xs,
                right: .none
            )
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
