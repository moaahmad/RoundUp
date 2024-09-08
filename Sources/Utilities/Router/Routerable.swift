//
//  Routerable.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 07/09/2024.
//

import UIKit

public protocol Routerable: AnyObject {
    var navigationController: UINavigationController { get }

    func popViewController(animated: Bool)
    func popToRootViewController(animated: Bool)
    func dismissViewController(animated: Bool, completion: (() -> Void)?)

    func pushViewController(viewController: UIViewController, animated: Bool)
    func setRootViewController(viewController: UIViewController, animated: Bool)
    func presentViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}
