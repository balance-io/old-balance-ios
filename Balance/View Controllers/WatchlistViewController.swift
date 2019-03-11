import UIKit
import CoreData
import Floaty
import SwiftEntryKit
import SnapKit

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let walletsTableView = UITableView()
    private let floaty = Floaty()
    
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
        
        setupFloaty()
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
    
    private func setupFloaty() {
        floaty.openAnimationType = .slideUp
        floaty.overlayColor = UIColor.black.withAlphaComponent(0.7)
        
        let ethItem = FloatyItem()
        ethItem.buttonColor = .black
        ethItem.title = "ETH Address"
        ethItem.icon = UIImage(named: "ethWhiteCircle")!
        ethItem.handler = { ethItem in
            let addEthereumWalletViewController = AddEthereumWalletViewController() { name, address, includeInBalance in
                CoreDataHelper.saveEthereumWallet(name: name, address: address)
                self.loadData()
            }
            self.present(addEthereumWalletViewController, animated: true)
        }
        floaty.addItem(item: ethItem)
        
        let contactItem = FloatyItem()
        contactItem.buttonColor = .black
        contactItem.title = "Contact"
        contactItem.icon = UIImage(named: "contact")!
        contactItem.handler = { ethItem in
            let alert = UIAlertController(title: "Soon™️", message: "Coming Soon", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.floaty.close()
        }
        
        let cdpItem = FloatyItem()
        cdpItem.buttonColor = .black
        cdpItem.title = "CDP"
        cdpItem.icon = UIImage(named: "cdp")!
        cdpItem.handler = { ethItem in
            let alert = UIAlertController(title: "Add a CDP number", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Enter the number. e.g. 3228"
                textField.keyboardType = .numberPad
            })
            
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                if let cdp = alert.textFields?.first?.text {
                    print("Your CDP: \(cdp)")
                    CoreDataHelper.saveMaker(singleCollateralDaiIdentifier: cdp)
                }
            }))
            self.present(alert, animated: true)
        }
        floaty.addItem(item: cdpItem)
        
        let deleteItem = FloatyItem()
        deleteItem.buttonColor = .black
        deleteItem.title = "Delete All"
        deleteItem.icon = UIImage(named: "trash")!
        deleteItem.handler = { ethItem in
            print("DELETE THINGS")
            CoreDataHelper.deleteAllData(entity: "Maker")
            CoreDataHelper.deleteAllData(entity: "Ethereum")
        }
        floaty.addItem(item: deleteItem)
        
        self.view.addSubview(floaty)
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
