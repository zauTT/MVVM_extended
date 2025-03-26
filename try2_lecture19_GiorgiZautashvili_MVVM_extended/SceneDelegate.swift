//
//  SceneDelegate.swift
//  lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 25.03.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let mainScreen = MainScreenViewController()
        let navController = UINavigationController(rootViewController: mainScreen)
        window?.rootViewController = UINavigationController(rootViewController: MainScreenViewController())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

}
