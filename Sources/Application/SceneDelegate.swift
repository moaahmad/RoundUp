//
//  SceneDelegate.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: RootCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        initializeRootCoordinator()
        window?.rootViewController = coordinator?.tabBarController
        window?.makeKeyAndVisible()
    }
}

private extension SceneDelegate {
    func initializeRootCoordinator() {
        coordinator = RootCoordinator(
            client: URLSessionHTTPClient(),
            tabBarController: STTabBarController()
        )
        coordinator?.start()
    }
}
