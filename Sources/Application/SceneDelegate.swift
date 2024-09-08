//
//  SceneDelegate.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: AppLaunchCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        initializeMainCoordinator()
        window?.rootViewController = coordinator?.tabBarController
        window?.makeKeyAndVisible()
    }

    private func initializeMainCoordinator() {
        let tabBarController = STTabBarController()
        tabBarController.configureItems()
        coordinator = AppLaunchCoordinator(tabBarController: tabBarController)
        coordinator?.start()
    }
}

final class STTabBarController: UITabBarController {
    func configureItems() {
        tabBar.itemPositioning = .centered
        tabBar.items?.forEach {
            $0.imageInsets = UIEdgeInsets(top: .xs, left: .none, bottom: -.xs, right: .none)
        }
    }
}
