//
//  TabBarController.swift
//  Balance
//
//  Created by Richard Burton on 3/9/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    private var welcomeViewController: WelcomeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let watchlistNavigationController = UINavigationController(rootViewController: WatchlistViewController())
        watchlistNavigationController.tabBarItem = UITabBarItem(title: "Watchlist",
                                                                image: UIImage(named: "watchlistTabBarItemImage"),
                                                                selectedImage: UIImage(named: "watchlistTabBarItemImageSelected"))

        
        let balanceNavigationController = UINavigationController(rootViewController: BalanceViewController())
        balanceNavigationController.tabBarItem = UITabBarItem(title: "Balance",
                                                              image: UIImage(named: "balanceTabBarItemImage"),
                                                              selectedImage: UIImage(named: "balanceTabBarItemImageSelected"))
        
        let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())
        settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings",
                                                               image: UIImage(named: "settingsTabBarItemImage"),
                                                               selectedImage: UIImage(named: "settingsTabBarItemImageSelected"))

        viewControllers = [watchlistNavigationController, balanceNavigationController, settingsNavigationController]
        
        self.selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CoreDataHelper.ethereumWalletCount() == 0 && welcomeViewController == nil {
            welcomeViewController = WelcomeViewController()
            present(welcomeViewController!, animated: false, completion: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(walletAdded), name: CoreDataHelper.Notifications.ethereumWalletAdded, object: nil)
        }
    }
    
    @objc private func walletAdded() {
        if welcomeViewController != nil {
            dismiss(animated: true)
            welcomeViewController = nil
        }
    }
    
    // NOTE: Probably not needed anymore, but if you see weird view issues then try it out
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        // Fixes iOS bug with view sizing
//        // NOTE: Do not call super here or it will crash
//        self.view.setNeedsLayout()
//    }
}
