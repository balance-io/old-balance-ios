import UIKit
import CoreData
import SwiftEntryKit

class BalanceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let cdpsTableView = UITableView()
    private var CDPs = [CDP]()
    
    // MARK - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        cdpsTableView.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
        cdpsTableView.dataSource = self
        cdpsTableView.delegate = self
        
        cdpsTableView.register(CDPTableViewCell.self, forCellReuseIdentifier: "cdpCell")
        view.addSubview(cdpsTableView)
        cdpsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        cdpsTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        cdpsTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        cdpsTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        cdpsTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        cdpsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        setupNavigation()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(walletAdded), name: CoreDataHelper.Notifications.ethereumWalletAdded, object: nil)
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
    
    private func loadData() {
        DispatchQueue.utility.async {
            var newCDPs = [CDP]()
            let dispatchGroup = DispatchGroup()
            
            // Load MakerDAO CDPs
            dispatchGroup.enter()
            let makers = CoreDataHelper.loadAllMakers()
            MakerToolsAPI.loadMakerCDPs(makers) { CDPs in
                newCDPs.append(contentsOf: CDPs)
                dispatchGroup.leave()
            }
            
            // Load Ethereum Wallets
            dispatchGroup.enter()
            let ethereumWallets = CoreDataHelper.loadAllEthereumWallets()
            MakerToolsAPI.loadEthereumWalletCDPs(ethereumWallets) { CDPs in
                newCDPs.append(contentsOf: CDPs)
                dispatchGroup.leave()
            }
            
            // Wait for results
            dispatchGroup.wait()
            DispatchQueue.main.async {
                self.CDPs = newCDPs
                self.cdpsTableView.reloadData()
            }
        }
    }
    
    @objc private func walletAdded() {
        loadData()
    }
        
    // MARK - Table View -

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CDPs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cdpCell", for: indexPath) as! CDPTableViewCell
        cell.selectionStyle = .none
        cell.cdp = CDPs[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("Row: \(indexPath.row)")
        
        var attributes = EKAttributes()
        attributes = .centerFloat
        attributes.name = "Top Note"
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
