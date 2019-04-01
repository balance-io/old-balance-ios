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
        // Sourcery defaults to 1 when the key is blank or missing
        ApiKeys.intercomApiKey == "1" ? nil : ApiKeys.intercomApiKey
    }()

    private static let appId: String? = {
        // Sourcery defaults to 1 when the key is blank or missing
        ApiKeys.intercomAppId == "1" ? nil : ApiKeys.intercomAppId
    }()

    static func setup() {
        guard let apiKey = apiKey, let appId = appId else {
            print("Intercom api key or app id are missing, you probably don't have the apikeys.sh file. Skipping Intercom setup.")
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
