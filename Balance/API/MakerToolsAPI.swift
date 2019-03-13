//
//  MakerToolsAPI.swift
//  Balance
//
//  Created by Benjamin Baron on 3/10/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation
import CoreData

struct MakerToolsAPI {
    private static let cdpBaseURL = URL(string: "https://mkr.tools/api/v1/cdp/")!
    private static let ethBaseURL = URL(string: "https://mkr.tools/api/v1/lad/")!
    
    static func loadMakerCDPs(_ makers: [NSManagedObject], completion: @escaping ([CDP]) -> ()) {
        DispatchQueue.utility.async {
            let ids = makers.compactMap { maker in
                maker.value(forKey: "singleCollateralDaiIdentifier") as? String
            }
            loadCDPs(ids: ids, baseURL: cdpBaseURL, completion: completion)
        }
    }
    
    static func loadEthereumWalletCDPs(_ ethereumWallets: [EthereumWallet], completion: @escaping ([CDP]) -> ()) {
        DispatchQueue.utility.async {
            let ids = ethereumWallets.compactMap { wallet in
                wallet.address
            }
            
            loadCDPs(ids: ids, baseURL: ethBaseURL, completion: completion)
        }
    }
    
    private static func loadCDPs(ids: [String], baseURL: URL, completion: @escaping ([CDP]) -> ()) {
        DispatchQueue.utility.async {
            var CDPs = [CDP]()
            let dispatchGroup = DispatchGroup()
            for id in ids {
                dispatchGroup.enter()
                let url = baseURL.appendingPathComponent(id)
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                    }
                    
                    do {
                        CDPs = try JSONDecoder().decode([CDP].self, from: data)
                    } catch {
                        print("Error", error)
                    }
                }
                task.resume()
            }
            
            dispatchGroup.wait()
            DispatchQueue.main.async {
                completion(CDPs)
            }
        }
    }
}
