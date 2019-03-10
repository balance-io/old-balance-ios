//
//  CoreDataHelper.swift
//  Balance
//
//  Created by Benjamin Baron on 3/10/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataHelper {
    static func loadAllMakers() -> [NSManagedObject] {
        return loadAllData(entity: "Maker")
    }
    
    static func loadAllEthereumWallets() -> [NSManagedObject] {
        return loadAllData(entity: "Ethereum")
    }
    
    static func loadAllData(entity: String) -> [NSManagedObject] {
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
    
    @discardableResult static func saveEthereumWallet(name: String, address: String) -> Bool {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Ethereum", in: managedContext) else {
            print("Could not save because entity could not be created")
            return false
        }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        managedObject.setValue(name, forKey: "name")
        managedObject.setValue(address, forKeyPath: "address")
        
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
    
    static func deleteAllData(entity: String) {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        print("FETCHING")
        print(fetchRequest)
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
