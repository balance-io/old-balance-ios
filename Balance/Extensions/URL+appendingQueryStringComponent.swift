//
//  URL+appendingQueryString.swift
//  Balance
//
//  Created by Jamie Rumbelow on 28/04/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation

extension URL {
    func appendingQueryStringComponent(_ key: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return absoluteURL
        }

        var existingQueryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        let newQueryItem = URLQueryItem(name: key, value: value)

        existingQueryItems.append(newQueryItem)
        urlComponents.queryItems = existingQueryItems

        return urlComponents.url!
    }
}
