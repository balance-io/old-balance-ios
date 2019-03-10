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
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Maker")
        var makers = [NSManagedObject]()
        do {
            makers = try managedContext.fetch(fetchRequest)
            print("DATABASE")
            print(makers)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return makers;
    }
    
    static func loadAllEthereumAddresses() -> [NSManagedObject] {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        var ethereumAddresses = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Ethereum")
        do {
            ethereumAddresses = try managedContext.fetch(fetchRequest)
            print("DATABASE")
            print(ethereumAddresses)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return ethereumAddresses
    }
}
