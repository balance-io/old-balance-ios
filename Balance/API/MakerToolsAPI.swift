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
    static func loadCDPs(makers: [NSManagedObject], completion: @escaping ([CDP]) -> ()) {
        DispatchQueue.utility.async {
            let singleCollateralDaiIdentifiers = makers.compactMap { maker in
                maker.value(forKey: "singleCollateralDaiIdentifier") as? String
            }
            
            var CDPs = [CDP]()
            let dispatchGroup = DispatchGroup()
            for identifier in singleCollateralDaiIdentifiers {
                // Biggest CDP
                guard let url = URL(string: "https://mkr.tools/api/v1/cdp/\(identifier)") else {
                    continue
                }
                
                dispatchGroup.enter()
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    guard let dataResponse = data, error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                    }
                    
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
