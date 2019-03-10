//
//  TabBarController.swift
//  Balance
//
//  Created by Richard Burton on 3/9/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    let watchlistViewController = WatchlistViewController()
    let balanceViewController = HomeViewController()
    let settingsViewController = SettingsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchlistViewController.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(named: "watchlistTabBarItemImage"), selectedImage: UIImage(named: "watchlistTabBarItemImageSelected"))
        balanceViewController.tabBarItem = UITabBarItem(title: "Balance", image: UIImage(named: "balanceTabBarItemImage"), selectedImage: UIImage(named: "balanceTabBarItemImageSelected"))
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settingsTabBarItemImage"), selectedImage: UIImage(named: "settingsTabBarItemImageSelected"))
        viewControllers = [watchlistViewController, balanceViewController, settingsViewController]
    }
}