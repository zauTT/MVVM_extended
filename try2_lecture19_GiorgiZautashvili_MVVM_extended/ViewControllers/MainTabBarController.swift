//
//  MainTabBarController.swift
//  try2_lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 27.03.25.
//


import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainScreenVC = UINavigationController(rootViewController: MainScreenViewController())
        mainScreenVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "House"), tag: 0)
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 2)
        
        self.viewControllers = [mainScreenVC, profileVC, favoritesVC]
    }
}
