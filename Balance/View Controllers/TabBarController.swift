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
    let balanceViewController = BalanceViewController()
    let settingsViewController = SettingsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchlistViewController.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(named: "watchlistTabBarItemImage"), selectedImage: UIImage(named: "watchlistTabBarItemImageSelected"))
        balanceViewController.tabBarItem = UITabBarItem(title: "Balance", image: UIImage(named: "balanceTabBarItemImage"), selectedImage: UIImage(named: "balanceTabBarItemImageSelected"))
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settingsTabBarItemImage"), selectedImage: UIImage(named: "settingsTabBarItemImageSelected"))
        viewControllers = [watchlistViewController, balanceViewController, settingsViewController]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Fixes iOS bug with view sizing
        // NOTE: Do not call super here or it will crash
        self.view.setNeedsLayout()
    }
}
