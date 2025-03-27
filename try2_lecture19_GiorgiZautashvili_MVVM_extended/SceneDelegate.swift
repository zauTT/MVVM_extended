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
        
        let mainNavController = UINavigationController(rootViewController: MainScreenViewController())
        let profileNavController = UINavigationController(rootViewController: ProfileViewController())
        let favoritesNavController = UINavigationController(rootViewController: FavoritesViewController())
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            createTabItem(for: mainNavController, title: "Movies", imageName: "film"),
            createTabItem(for: profileNavController, title: "Profile", imageName: "person.circle"),
            createTabItem(for: favoritesNavController, title: "Favorites", imageName: "heart")
        ]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func createTabItem(for rootVC: UIViewController, title: String, imageName: String) -> UIViewController {
        rootVC.tabBarItem.title = title
        rootVC.tabBarItem.image = UIImage(systemName: imageName)
        return rootVC
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
    
}
