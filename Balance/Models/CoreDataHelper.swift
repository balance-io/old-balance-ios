import Foundation
import CoreData

struct CoreDataHelper {
    struct Notifications {
        static let ethereumWalletAdded = Notification.Name(rawValue: "CoreDataHelper.ethereumWalletAdded")
        static let ethereumWalletRemoved = Notification.Name(rawValue: "CoreDataHelper.ethereumWalletRemoved")
    }
    
    static func loadAllEthereumWallets(managedWallets: [NSManagedObject]? = nil) -> [EthereumWallet] {
        let managedEthereumWallets = managedWallets ?? loadAllManagedEthereumWallets()
        var ethereumWallets = [EthereumWallet]()
        for managedWallet in managedEthereumWallets {
            let name = managedWallet.value(forKey: "name") as? String ?? ""
            let address = managedWallet.value(forKey: "address") as? String ?? ""
            let includeInTotal = managedWallet.value(forKey: "includeInTotal") as? Bool ?? true
            ethereumWallets.append(EthereumWallet(name: name, address: address, includeInTotal: includeInTotal))
        }
        return ethereumWallets
    }
    
    static func loadAllManangedMakers() -> [NSManagedObject] {
        return loadAll(entity: "Maker")
    }
    
    static func loadAllManagedEthereumWallets() -> [NSManagedObject] {
        return loadAll(entity: "Ethereum")
    }
    
    static func loadAll(entity: String) -> [NSManagedObject] {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        var managedObjects = [NSManagedObject]()
        do {
            managedObjects = try managedContext.fetch(fetchRequest)
            print("DATABASE")
            print(managedObjects)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return managedObjects;
    }
    
    static func ethereumWalletCount() -> Int {
        return count(entity: "Ethereum")
    }
    
    static func count(entity: String) -> Int {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        var count = 0
        do {
            count = try managedContext.count(for: fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return count
    }
    
    @discardableResult static func saveMaker(singleCollateralDaiIdentifier: String) -> Bool {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Maker", in: managedContext) else {
            print("Could not save because entity could not be created")
            return false
        }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        managedObject.setValue(singleCollateralDaiIdentifier, forKeyPath: "singleCollateralDaiIdentifier")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    @discardableResult static func save(ethereumWallet: EthereumWallet) -> Bool {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Ethereum", in: managedContext) else {
            print("Could not save because entity could not be created")
            return false
        }
        
        // First check if there are already 10 wallets (this will be a Pro feature)
        let ethereumWallets = loadAllEthereumWallets()
        guard ethereumWallets.count < 10 else {
            print("There are already 10 wallets, so not saving: \(ethereumWallet.address)")
            return false
        }
        
        // Then check if this wallet address already exists
        guard !ethereumWallets.contains(where: { $0.address == ethereumWallet.address }) else {
            print("This wallet address already exists, so not saving: \(ethereumWallet.address)")
            return false
        }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        managedObject.setValue(ethereumWallet.name, forKey: "name")
        managedObject.setValue(ethereumWallet.address, forKeyPath: "address")
        managedObject.setValue(ethereumWallet.includeInTotal, forKey: "includeInTotal")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    static func delete(managedObject: NSManagedObject) -> Bool {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        managedContext.delete(managedObject)
        do {
            try managedContext.save()
            return true
        } catch let error {
            print("Could not save Deletion \(error)")
            return false
        }
    }
    
    static func delete(entity: String) {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            print(results)
            for managedObject in results {
                if let managedObjectData = managedObject as? NSManagedObject {
                    managedContext.delete(managedObjectData)
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
}
