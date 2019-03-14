//
//  BalanceViewController.swift
//  Balance
//
//  Created by Richard Burton on 3/9/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit
import CoreData
import SwiftEntryKit

class BalanceViewController: UITableViewController {
    enum Section: Int {
        case ethereum = 0
        case erc20    = 1
        case cdp      = 2
    }

    private var ethereumWallets = [EthereumWallet]()
    private var aggregatedEthereumWallet: EthereumWallet?
    private var CDPs = [CDP]()
    
    // MARK - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "#fbfbfb")
        
        tableView.backgroundColor = UIColor(hexString: "#fbfbfb")
        tableView.separatorStyle = .none
        tableView.register(CDPBalanceTableViewCell.self, forCellReuseIdentifier: "cdpCell")
        
        setupNavigation()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(walletAdded), name: CoreDataHelper.Notifications.ethereumWalletAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(walletRemoved), name: CoreDataHelper.Notifications.ethereumWalletRemoved, object: nil)
    }
    
    private func setupNavigation() {
        navigationItem.title = ""
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = .white
            navigationBar.isTranslucent = false
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }
    
    // MARK - Data Loading -
    
    func loadData() {
        DispatchQueue.utility.async {
            var newEthereumWallets = CoreDataHelper.loadAllEthereumWallets()
            var newAggregatedEthereumWallet: EthereumWallet?
            var newCDPs = [CDP]()
            
            guard newEthereumWallets.count > 0 else {
                // This should never happen
                self.CDPs = newCDPs
                self.ethereumWallets = newEthereumWallets
                self.aggregatedEthereumWallet = newAggregatedEthereumWallet
                self.tableView.reloadData()
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            // Load balances first
            dispatchGroup.enter()
            EthplorerAPI.loadWalletBalances(newEthereumWallets) { wallets in
                newEthereumWallets = wallets
                dispatchGroup.leave()
            }
            
            // Load CDPs
            dispatchGroup.enter()
            MakerToolsAPI.loadEthereumWalletCDPs(newEthereumWallets) { CDPs in
                newCDPs.append(contentsOf: CDPs)
                dispatchGroup.leave()
            }
            
            // Wait for results
            dispatchGroup.wait()
            
            // Load ethereum price
            dispatchGroup.enter()
            CoinMarketCapAPI.loadEthereumPrice(newEthereumWallets) { wallets, success in
                newEthereumWallets = wallets
                dispatchGroup.leave()
            }
            
            // Wait for results
            dispatchGroup.wait()
            
            // Aggregate the balances
            newAggregatedEthereumWallet = EthereumWallet.aggregated(wallets: newEthereumWallets)
            
            // Store the results and reload the table
            DispatchQueue.main.async {
                // Sort by CDP number
                self.CDPs = newCDPs.sorted { left, right -> Bool in
                    if let leftId = left.id, let rightId = right.id {
                        return leftId < rightId
                    }
                    return false
                }
                self.ethereumWallets = newEthereumWallets
                self.aggregatedEthereumWallet = newAggregatedEthereumWallet
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func walletAdded() {
        loadData()
    }
    
    @objc private func walletRemoved() {
        loadData()
    }
        
    // MARK - Table View -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionEnum = Section(rawValue: section) else {
            return 0
        }
        
        switch sectionEnum {
        case .ethereum:
            return ethereumWallets.count > 0 ? 1 : 0
        case .erc20:
            // Check if there are any tokens
            for wallet in ethereumWallets {
                if let count = wallet.tokens?.count, count > 0 {
                    return 1
                }
            }
            return 0
        case .cdp:
            return CDPs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.ethereum.rawValue {
            return CryptoBalanceTableViewCell(wallet: aggregatedEthereumWallet!, cryptoType: .ethereum)
        } else if indexPath.section == Section.erc20.rawValue {
            return CryptoBalanceTableViewCell(wallet: aggregatedEthereumWallet!, cryptoType: .erc20)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cdpCell", for: indexPath) as! CDPBalanceTableViewCell
            cell.cdp = CDPs[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Section.ethereum.rawValue {
            return CryptoBalanceTableViewCell.calculatedHeight(wallet: aggregatedEthereumWallet!, cryptoType: .ethereum)
        } else if indexPath.section == Section.erc20.rawValue {
            return CryptoBalanceTableViewCell.calculatedHeight(wallet: aggregatedEthereumWallet!, cryptoType: .erc20)
        } else {
            return 180
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == Section.cdp.rawValue else {
            return
        }
        
        var attributes = EKAttributes()
        attributes = .centerFloat
        attributes.name = "CDP Info"
        attributes.hapticFeedbackType = .success
        attributes.popBehavior = .animated(animation: .translation)
        attributes.entryBackground = .color(color: .black)
        attributes.roundCorners = .all(radius: 20)
        attributes.border = .none
        attributes.statusBar = .hidden
        attributes.screenBackground = .color(color: UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.8))
        attributes.positionConstraints.rotation.isEnabled = false
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 2))
        attributes.statusBar = .ignored
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.positionConstraints.rotation.isEnabled = false
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.95)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        let cdpInfoView = CDPInfoView(cdpItem: CDPs[indexPath.row])
        SwiftEntryKit.display(entry: cdpInfoView, using: attributes)
    }
}
