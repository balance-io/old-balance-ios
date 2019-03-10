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
            let identifiers = makers.compactMap { maker in
                maker.value(forKey: "singleCollateralDaiIdentifier") as? String
            }
            loadCDPs(identifiers: identifiers, baseURL: cdpBaseURL, completion: completion)
        }
    }
    
    static func loadEthereumAddressCDPs(_ ethereumAddresses: [NSManagedObject], completion: @escaping ([CDP]) -> ()) {
        DispatchQueue.utility.async {
            let identifiers = ethereumAddresses.compactMap { maker in
                maker.value(forKey: "address") as? String
            }
            loadCDPs(identifiers: identifiers, baseURL: cdpBaseURL, completion: completion)
        }
    }
    
    private static func loadCDPs(identifiers: [String], baseURL: URL, completion: @escaping ([CDP]) -> ()) {
        DispatchQueue.utility.async {
            var CDPs = [CDP]()
            let dispatchGroup = DispatchGroup()
            for identifier in identifiers {
                // Biggest CDP
                let url = baseURL.appendingPathComponent(identifier)
                dispatchGroup.enter()
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    guard let dataResponse = data, error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                    }
                    
                    //debugPrint(String(data: dataResponse, encoding: String.Encoding.utf8)!)
                    
                    do {
                        guard let jsonArray = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? [[String: Any]] else {
                            return
                        }
                        print(jsonArray)
                        
                        for dic in jsonArray {
                            guard let identifier = dic["id"] as? Int else { return }
                            guard let ratio = dic["ratio"] as? Double else { return }
                            guard let pip = dic["pip"] as? Double else { return }
                            guard let art = dic["art"] as? Double else { return }
                            guard let ink = dic["ink"] as? Double else { return }
                            guard let liqPrice = dic["liq_price"] as? Double else { return }
                            CDPs.append(CDP(identifier: identifier, ratio: ratio, pip: pip, art: art, ink: ink, liqPrice: liqPrice))
                        }
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
