import UIKit
import CoreData
import Floaty
import SwiftEntryKit

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let walletsTableView = UITableView()
    private let floaty = Floaty()
    
    private var managedEthereumWallets = [NSManagedObject]()
    private var ethereumWallets = [EthereumWallet]()
    
    func setUpNavigation() {
        navigationItem.title = ""
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = .white
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        walletsTableView.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
        managedEthereumWallets = CoreDataHelper.loadAllEthereumWallets()
        if managedEthereumWallets.count > 0 {
            for wallet in managedEthereumWallets {
                ethereumWallets.append(EthereumWallet(name: String(wallet.value(forKey: "name") as! String), address: String(wallet.value(forKey: "address") as! String)))
            }
        }
        
        walletsTableView.dataSource = self
        walletsTableView.delegate = self
        
        walletsTableView.register(WalletTableViewCell.self, forCellReuseIdentifier: "walletCell")
        view.addSubview(walletsTableView)
        walletsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        walletsTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        walletsTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        walletsTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        walletsTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        walletsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        floaty.openAnimationType = .slideUp
        floaty.overlayColor = UIColor.black.withAlphaComponent(0.7)
        
        let ethItem = FloatyItem()
        ethItem.buttonColor = .black
        ethItem.title = "ETH Address"
        ethItem.icon = UIImage(named: "ethWhiteCircle")!
        ethItem.handler = { ethItem in
            let alert = UIAlertController(title: "Add an ETH address", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Wallet Name"
            })
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Enter a wallet address beginning in 0x..."
            })
            
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                if let name = alert.textFields?.first?.text, let address = alert.textFields?.last?.text {
                    CoreDataHelper.saveEthereumWallet(name: name, address: address)
                }
            }))
            self.present(alert, animated: true)
        }
        floaty.addItem(item: ethItem)
        
        let contactItem = FloatyItem()
        contactItem.buttonColor = .black
        contactItem.title = "Contact"
        contactItem.icon = UIImage(named: "contact")!
        contactItem.handler = { ethItem in
            let alert = UIAlertController(title: "Soon™️", message: "Coming Soon", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        
        setUpNavigation()
//        getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ethereumWallets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! WalletTableViewCell
        cell.selectionStyle = .none
        cell.wallet = ethereumWallets[indexPath.row]
        return cell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
