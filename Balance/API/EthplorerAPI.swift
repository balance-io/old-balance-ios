//
//  EthplorerAPI.swift
//  Balance
//
//  Created by Benjamin Baron on 3/12/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation

struct EthplorerAPI {
    private static let baseURL = URL(string: "https://api.ethplorer.io/")
    private static let apiKey: String = {
        // Try to read from a plist file
        // Updates to this file are not checked into git, so for release, make sure you have the real key in your local file
        if let path = Bundle.main.path(forResource: "apikeys", ofType: "plist") {
            if let dictionary = NSDictionary(contentsOfFile: path), let apiKey = dictionary.value(forKey: "ethplorer") as? String {
                print(apiKey)
                return apiKey
            }
        }
        
        // Default free api key
        return "freekey"
    }()
    
    
}
