import Foundation
import PagingKit
import SnapKit

class BalanceViewController: UIViewController, PagingMenuViewControllerDataSource, PagingContentViewControllerDataSource, PagingMenuViewControllerDelegate, PagingContentViewControllerDelegate {
    
    private var menuViewController = PagingMenuViewController()
    private var contentViewController = PagingContentViewController()

    private let menuBackgroundView: UIView = {
        let menuBackgroundView = UIView()
        menuBackgroundView.backgroundColor = .white
        return menuBackgroundView
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let loadingSpinner = UIActivityIndicatorView(style: .whiteLarge)
        loadingSpinner.color = .gray
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.startAnimating()
        return loadingSpinner
    }()
    
    private var isLoading = false
    private var lastLoadTimestamp = 0.0
    
    private var contentViewControllers = [BalanceContentViewController]()
    private var ethereumWallets = [EthereumWallet]()
    private var aggregatedEthereumWallet: EthereumWallet?
    
    // MARK - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "#fbfbfb")
        
        menuBackgroundView.isHidden = true
        view.addSubview(menuBackgroundView)
        menuBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // Setup first load spinner
        view.addSubview(loadingSpinner)
        loadingSpinner.snp.makeConstraints { make in
            make.top.equalTo(menuBackgroundView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(walletAdded), name: CoreDataHelper.Notifications.ethereumWalletAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(walletRemoved), name: CoreDataHelper.Notifications.ethereumWalletRemoved, object: nil)
    }
    
    private func addPagingController() {
        menuBackgroundView.isHidden = false
        
        // Setup menu
        menuViewController.delegate = self
        menuViewController.dataSource = self
        menuViewController.register(type: MenuViewTitleCell.self, forCellWithReuseIdentifier: "MenuViewTitleCell")
        menuViewController.registerFocusView(view: MenuUnderlineView())
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        menuViewController.view.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // Setup content
        contentViewController.delegate = self
        contentViewController.dataSource = self
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        contentViewController.view.snp.makeConstraints { make in
            make.top.equalTo(menuViewController.view.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func removePagingController() {
        menuBackgroundView.isHidden = true
        menuViewController.view.removeFromSuperview()
        menuViewController.removeFromParent()
        contentViewController.view.removeFromSuperview()
        contentViewController.removeFromParent()
        contentViewControllers.removeAll()
    }
    
    // MARK - Data Loading -
    
    private func updateContentControllers() {
        if contentViewControllers.count == 0 {
            addPagingController()
            
            let balanceContentViewController = BalanceContentViewController()
            balanceContentViewController.ethereumWallet = aggregatedEthereumWallet
            balanceContentViewController.title = "All Wallets"
            contentViewControllers.append(balanceContentViewController)
            
            for ethereumWallet in ethereumWallets {
                let balanceContentViewController = BalanceContentViewController()
                balanceContentViewController.ethereumWallet = ethereumWallet
                balanceContentViewController.title = ethereumWallet.name ?? ethereumWallet.address
                contentViewControllers.append(balanceContentViewController)
            }
        } else {
            contentViewControllers[0].ethereumWallet = aggregatedEthereumWallet
            for (index, ethereumWallet) in ethereumWallets.enumerated() {
                contentViewControllers[index + 1].ethereumWallet = ethereumWallet
                contentViewControllers[index + 1].title = ethereumWallet.name ?? ethereumWallet.address
            }
        }
        
        menuViewController.reloadData()
        contentViewController.reloadData()
        for contentViewController in contentViewControllers {
            contentViewController.reloadData()
        }
        
        // Fix for menu not showing up on first load
        menuViewController.menuView.contentOffset.y = 0
    }
    
    @objc func loadData() {
        guard CoreDataHelper.ethereumWalletCount() > 0 else {
            ethereumWallets = [EthereumWallet]()
            aggregatedEthereumWallet = nil
            contentViewControllers = [BalanceContentViewController]()
            updateContentControllers()
            return
        }
        
        if isLoading {
            // Wait a bit and try again
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadData), object: nil)
            perform(#selector(loadData), with: nil, afterDelay: 0.5)
            return
        }
        
        let delay = EthplorerAPI.isFreeApiKey ? 2.0 : 1.0
        let secondsSinceLastLoad = NSDate().timeIntervalSince1970 - lastLoadTimestamp
        if secondsSinceLastLoad < delay {
            // Wait a few seconds and try again
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadData), object: nil)
            perform(#selector(loadData), with: nil, afterDelay: delay - secondsSinceLastLoad)
            return
        }
        
        isLoading = true
        DispatchQueue.utility.async {
            var newEthereumWallets = CoreDataHelper.loadAllEthereumWallets()
            var newAggregatedEthereumWallet: EthereumWallet?
            
            // Extra check in case of race condition
            guard newEthereumWallets.count > 0 else {
                self.ethereumWallets = newEthereumWallets
                self.aggregatedEthereumWallet = newAggregatedEthereumWallet
                self.contentViewControllers = [BalanceContentViewController]()
                self.isLoading = false
                DispatchQueue.main.async {
                    self.updateContentControllers()
                }
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
            var newEthereumWalletsCDPs = [EthereumWallet]()
            MakerToolsAPI.loadEthereumWalletCDPs(newEthereumWallets) { wallets in
                newEthereumWalletsCDPs = wallets
                dispatchGroup.leave()
            }
            
            // Wait for results
            dispatchGroup.wait()
            
            // Copy the CDPs into the main wallet array
            // NOTE: This is a little clunky but it allows us to load both APIs at once
            for index in 0 ..< newEthereumWallets.count {
                newEthereumWallets[index].CDPs = newEthereumWalletsCDPs[index].CDPs
            }
            
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
                self.ethereumWallets = newEthereumWallets
                self.aggregatedEthereumWallet = newAggregatedEthereumWallet
                self.lastLoadTimestamp = Date().timeIntervalSince1970
                self.isLoading = false
                self.loadingSpinner.stopAnimating()
                self.updateContentControllers()
            }
        }
    }
    
    @objc private func walletAdded() {
        walletsChanged()
    }
    
    @objc private func walletRemoved() {
        walletsChanged()
    }
    
    private func walletsChanged() {
//        menuBackgroundView.isHidden = true
//        contentViewControllers.removeAll()
//        menuViewController.reloadData()
//        contentViewController.reloadData()
        removePagingController()
        loadingSpinner.startAnimating()
        loadData()
    }
    
    // MARK: - PagingKit -
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MenuViewTitleCell", for: index)  as! MenuViewTitleCell
        cell.titleLabel.text = contentViewControllers[index].title
        return cell
    }
    
    private static let sizingCell = MenuViewTitleCell()
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        BalanceViewController.sizingCell.titleLabel.text = contentViewControllers[index].title
        var referenceSize = UIView.layoutFittingCompressedSize
        referenceSize.height = viewController.view.bounds.height
        let size = BalanceViewController.sizingCell.systemLayoutSizeFitting(referenceSize)
        return size.width
    }
    
    var insets: UIEdgeInsets {
        return view.safeAreaInsets
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return contentViewControllers.count
    }
    
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return contentViewControllers.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return contentViewControllers[index]
    }
    
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
    
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
