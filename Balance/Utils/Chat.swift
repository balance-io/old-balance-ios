//
//  Chat.swift
//  Balance
//
//  Created by Benjamin Baron on 3/21/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation
import Intercom

struct Chat {
    static let showButton: Bool = {
        apiKey != nil
    }()

    private static let apiKey: String? = {
        // Try to read from a plist file
        // Updates to this file are not checked into git, so for release, make sure you have the real key in your local file
        if let path = Bundle.main.path(forResource: "apikeys", ofType: "plist") {
            if let dictionary = NSDictionary(contentsOfFile: path), let intercom = dictionary.value(forKey: "intercom") as? NSDictionary, let apiKey = intercom.value(forKey: "apiKey") as? String {
                return apiKey
            }
        }

        // If no API key is set (plist is missing), return nil and we won't initialize Intercom
        return nil
    }()

    private static let appId: String? = {
        // Try to read from a plist file
        // Updates to this file are not checked into git, so for release, make sure you have the real key in your local file
        if let path = Bundle.main.path(forResource: "apikeys", ofType: "plist") {
            if let dictionary = NSDictionary(contentsOfFile: path), let intercom = dictionary.value(forKey: "intercom") as? NSDictionary, let appId = intercom.value(forKey: "appId") as? String {
                return appId
            }
        }

        // If no app ID is set (plist is missing), return nil and we won't initialize Intercom
        return nil
    }()

    static func setup() {
        guard let apiKey = apiKey, let appId = appId else {
            print("Intercom api key or app id are missing, you probably don't have the apikeys.plist file. Skipping Intercom setup.")
            return
        }

        Intercom.setApiKey(apiKey, forAppId: appId)
        Intercom.setLauncherVisible(false)
        Intercom.registerUnidentifiedUser()
    }

    static func show() {
        Intercom.presentMessenger()
    }
}
