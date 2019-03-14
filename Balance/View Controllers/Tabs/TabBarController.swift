//
//  TabBarController.swift
//  Balance
//
//  Created by Richard Burton on 3/9/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    private enum TabIndex: Int {
        case watchlist = 0
        case balance   = 1
        case settings  = 2
    }
    
    let watchlistViewController = WatchlistViewController()
    let balanceViewController = BalanceViewController()
    let settingsViewController = SettingsViewController()
    
    private var welcomeViewController: WelcomeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let watchlistNavigationController = UINavigationController(rootViewController: watchlistViewController)
        watchlistNavigationController.tabBarItem = UITabBarItem(title: "Watchlist",
                                                                image: UIImage(named: "watchlistTabBarItemImage"),
                                                                selectedImage: UIImage(named: "watchlistTabBarItemImageSelected"))
        
        let balanceNavigationController = UINavigationController(rootViewController: balanceViewController)
        balanceNavigationController.tabBarItem = UITabBarItem(title: "Balance",
                                                              image: UIImage(named: "balanceTabBarItemImage"),
                                                              selectedImage: UIImage(named: "balanceTabBarItemImageSelected"))
        
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings",
                                                               image: UIImage(named: "settingsTabBarItemImage"),
                                                               selectedImage: UIImage(named: "settingsTabBarItemImageSelected"))

        viewControllers = [watchlistNavigationController, balanceNavigationController, settingsNavigationController]
        
        self.selectedIndex = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CoreDataHelper.ethereumWalletCount() == 0 && welcomeViewController == nil {
            welcomeViewController = WelcomeViewController()
            present(welcomeViewController!, animated: false, completion: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // NOTE: Don't call super here or it will crash
        if tabBar.items?.firstIndex(of: item) == TabIndex.balance.rawValue {
            balanceViewController.loadData()
        }
    }
    
    @objc private func walletAdded() {
        if welcomeViewController != nil {
            dismiss(animated: true)
            welcomeViewController = nil
        }
    }
}
