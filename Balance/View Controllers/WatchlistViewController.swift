import UIKit
import CoreData
import Floaty
import SwiftEntryKit

private var ethereumWallets = [EthereumWallet]()
var wallets: [NSManagedObject] = []

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let walletsTableView = UITableView()
    let floaty = Floaty()
    
    func setUpNavigation() {
        navigationItem.title = ""
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        walletsTableView.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Ethereum")
        
        do {
            wallets = try managedContext.fetch(fetchRequest)
            print("DATABASE")
            print(wallets)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if wallets.count > 0 {
            for wallet in wallets {
                ethereumWallets.append(EthereumWallet(name: String(wallet.value(forKey: "name") as! String), address: String(wallet.value(forKey: "address") as! String)))
            }
        } else {
            ethereumWallets.removeAll()
            self.walletsTableView.reloadData()
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
                
                if let ethereumAddress = alert.textFields?.last?.text {
                    if let walletName = alert.textFields?.first?.text {
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                            return
                        }
                        
                        let managedContext = appDelegate.persistentContainer.viewContext
                        
                        let entity = NSEntityDescription.entity(forEntityName: "Ethereum", in: managedContext)!
                        
                        let ethereumObject = NSManagedObject(entity: entity, insertInto: managedContext)
                        
                        ethereumObject.setValue(walletName, forKey: "name")
                        ethereumObject.setValue(ethereumAddress, forKeyPath: "address")
                    }
        
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
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
                    
                    guard let appDelegate =
                        UIApplication.shared.delegate as? AppDelegate else {
                            return
                    }
                    
                    let managedContext =
                        appDelegate.persistentContainer.viewContext
                    
                    let entity =
                        NSEntityDescription.entity(forEntityName: "Maker",
                                                   in: managedContext)!
                    
                    let maker = NSManagedObject(entity: entity,
                                                insertInto: managedContext)
                    
                    maker.setValue(cdp, forKeyPath: "singleCollateralDaiIdentifier")
                    
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
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
            self.deleteAllData("Maker")
            self.deleteAllData("Ethereum")
        }
        floaty.addItem(item: deleteItem)
        
        self.view.addSubview(floaty)
        
        setUpNavigation()
//        getData()
    }
    
    func deleteAllData(_ entity:String) {
        
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        print("FETCHING")
        print(fetchRequest)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            print(results)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
                try context.save()
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ethereumWallets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! WalletTableViewCell
        cell.selectionStyle = .none
        cell.wallet = ethereumWallets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
            let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
            
            let objectToDelete = wallets[indexPath.row]
            ethereumWallets.remove(at: indexPath.row)
            context.delete(objectToDelete)
            
            do {
                try context.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error {
                print("Could not save Deletion \(error)")
            }
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
