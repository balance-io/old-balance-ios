import UIKit
import CoreData
import SwiftEntryKit
import SnapKit

class WalletsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var managedEthereumWallets = [NSManagedObject]()
    private var ethereumWallets = [EthereumWallet]()
    
    private let addButton: UIButton = {
        let addButton = UIButton()
        addButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        addButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        addButton.contentEdgeInsets = UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 15)
        addButton.backgroundColor = UIColor.init(hexString: "#d1d3d5")
        addButton.layer.cornerRadius = 5
        addButton.setTitle("Add", for: UIControl.State.normal)
        addButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        addButton.setImage(UIImage(named:"plusIcon"), for: .normal)
        return addButton
    }()

    private let walletsTableView = UITableView()
    
    // MARK: - View Controller Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#fbfbfb")
        
        walletsTableView.backgroundColor = UIColor(hexString: "#fbfbfb")
        walletsTableView.separatorStyle = .none
        walletsTableView.rowHeight = 100
        walletsTableView.dataSource = self
        walletsTableView.delegate = self
        
        walletsTableView.register(NamedWalletTableViewCell.self, forCellReuseIdentifier: "namedWalletCell")
        view.addSubview(walletsTableView)
        
        walletsTableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
        
        setupNavigation()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(walletAdded), name: CoreDataHelper.Notifications.ethereumWalletAdded, object: nil)
    }
    
    private func setupNavigation() {
        navigationItem.title = ""
        navigationItem.titleView = addButton
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(72)
            make.width.equalTo(72)
        }
        
        if Chat.showButton {
            let chatButton = UIButton()
            chatButton.setImage(UIImage(named: "chatButton"), for: .normal)
            chatButton.addTarget(self, action: #selector(chatAction), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: chatButton)
        }
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = .white
            navigationBar.isTranslucent = false
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }
    
    // MARK: - Button Actions -
    
    @objc private func addAction() {
        let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        lightImpactFeedbackGenerator.prepare()
        lightImpactFeedbackGenerator.impactOccurred()

        if ethereumWallets.count >= 10 {
            let alert = UIAlertController(title: "Upgrade to Balance Pro", message: "Upgrade to add more than 10 wallets (coming soon)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            let addEthereumWalletViewController = AddEthereumWalletViewController()
            present(addEthereumWalletViewController, animated: true)
        }
    }
    
    @objc private func chatAction() {
        Chat.show()
    }
    
    // MARK: - Data Loading -
    
    private func loadData() {
        managedEthereumWallets = CoreDataHelper.loadAllManagedEthereumWallets()
        ethereumWallets = CoreDataHelper.loadAllEthereumWallets(managedWallets: managedEthereumWallets)
        walletsTableView.reloadData()
    }
    
    @objc private func walletAdded() {
        loadData()
        if presentedViewController != nil {
            dismiss(animated: true)
            let heavyImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            heavyImpactFeedbackGenerator.prepare()
            heavyImpactFeedbackGenerator.impactOccurred()
        }
    }
    
    // MARK: - Table View -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ethereumWallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wallet = ethereumWallets[indexPath.row]
        var cell: WalletTableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "namedWalletCell", for: indexPath) as! NamedWalletTableViewCell
        
        cell.selectionStyle = .none
        cell.wallet = wallet
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var attributes = EKAttributes()
        attributes = .centerFloat
        attributes.name = "Wallet Info"
        attributes.hapticFeedbackType = .success
        attributes.popBehavior = .animated(animation: .translation)
        attributes.entryBackground = .color(color: .clear)//.color(color: .black)
        attributes.border = .none
        attributes.statusBar = .hidden
        attributes.screenBackground = .color(color: UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.8))
        attributes.positionConstraints.rotation.isEnabled = false
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 2))
        attributes.statusBar = .ignored
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .forward
        attributes.positionConstraints.rotation.isEnabled = false
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.95)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        let walletInfoView = WalletInfoView(wallet: ethereumWallets[indexPath.row])
        SwiftEntryKit.display(entry: walletInfoView, using: attributes)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if CoreDataHelper.delete(managedObject: managedEthereumWallets[indexPath.row]) {
                managedEthereumWallets.remove(at: indexPath.row)
                ethereumWallets.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                NotificationCenter.default.post(name: CoreDataHelper.Notifications.ethereumWalletRemoved, object: nil)
            }
        }
    }
}
