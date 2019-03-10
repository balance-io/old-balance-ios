//
//  TabBarController.swift
//  Balance
//
//  Created by Richard Burton on 3/9/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let watchlistViewController = WatchlistViewController()
        
        watchlistViewController.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(named: "watchlistTabBarItemImage.png"), selectedImage: UIImage(named: "watchlistTabBarItemImageSelected.png"))
        
        let balanceViewController = HomeViewController()
        balanceViewController.tabBarItem = UITabBarItem(title: "Balance", image: UIImage(named: "balanceTabBarItemImage.png"), selectedImage: UIImage(named: "balanceTabBarItemImageSelected.png"))
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settingsTabBarItemImage.png"), selectedImage: UIImage(named: "settingsTabBarItemImageSelected.png"))
        
        let tabBarList = [watchlistViewController, balanceViewController, settingsViewController]
        
        viewControllers = tabBarList
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
