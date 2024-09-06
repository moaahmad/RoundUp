//
//  SceneDelegate.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        initializeMainCoordinator()
    }


    private func initializeMainCoordinator() {
        let tabBarController = STTabBarController()
        tabBarController.configureItems()
        coordinator = MainCoordinator(tabBarController: tabBarController)
        coordinator?.start()

        window?.rootViewController = coordinator?.tabBarController
        window?.makeKeyAndVisible()
    }
}

final class STTabBarController: UITabBarController {
    func configureItems() {
        tabBar.itemPositioning = .centered
        tabBar.items?.forEach {
            $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}
