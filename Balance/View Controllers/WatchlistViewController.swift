import UIKit
import CoreData
import Floaty
import SwiftEntryKit
import SnapKit

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let walletsTableView = UITableView()
    
    private var managedEthereumWallets = [NSManagedObject]()
    private var ethereumWallets = [EthereumWallet]()
    
    // MARK: - View Controller Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
        walletsTableView.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        walletsTableView.separatorStyle = .none
        walletsTableView.dataSource = self
        walletsTableView.delegate = self
        
        walletsTableView.register(WalletTableViewCell.self, forCellReuseIdentifier: "walletCell")
        view.addSubview(walletsTableView)
        
        walletsTableView.translatesAutoresizingMaskIntoConstraints = false
        walletsTableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
        
        setupNavigation()
        loadData()
    }
    
    private func setupNavigation() {
        navigationItem.title = ""
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = .white
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }
    
    // MARK: - Data Loading -
    
    private func loadData() {
        managedEthereumWallets = CoreDataHelper.loadAllEthereumWallets()
        ethereumWallets = [EthereumWallet]()
        if managedEthereumWallets.count > 0 {
            for wallet in managedEthereumWallets {
                ethereumWallets.append(EthereumWallet(name: String(wallet.value(forKey: "name") as! String), address: String(wallet.value(forKey: "address") as! String)))
            }
        }
        walletsTableView.reloadData()
    }
    
    // MARK: - Table View -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ethereumWallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! WalletTableViewCell
        cell.selectionStyle = .none
        cell.wallet = ethereumWallets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if CoreDataHelper.delete(managedObject: managedEthereumWallets[indexPath.row]) {
                managedEthereumWallets.remove(at: indexPath.row)
                ethereumWallets.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
