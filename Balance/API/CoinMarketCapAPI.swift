//
//  CoinMarketCapAPI.swift
//  Balance
//
//  Created by Benjamin Baron on 3/12/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation

struct CoinMarketCapAPI {
    static func loadTicker(completion: @escaping ([TickerResponse]) -> ()) {
        DispatchQueue.utility.async {
            var tickerResponses = [TickerResponse]()
            // NOTE: Remove "ethereum/" from the end to get all cryptocurrencies
            let url = URL(string: "https://api.coinmarketcap.com/v1/ticker")!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }
                debugPrint(String(data: data, encoding: .utf8)!)
                
                do {
                    tickerResponses = try JSONDecoder().decode([TickerResponse].self, from: data)
                } catch {
                    print("Error getting ticker from CoinMarketCap: ", error)
                }
                
                DispatchQueue.main.async {
                    completion(tickerResponses)
                }
            }
            task.resume()
        }
    }
    
    static func loadEthereumTicker(completion: @escaping (TickerResponse?) -> ()) {
        DispatchQueue.utility.async {
            var tickerResponse: TickerResponse?
            let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/ethereum")!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }
                
                do {
                    let tickerResponses = try JSONDecoder().decode([TickerResponse].self, from: data)
                    tickerResponse = tickerResponses.first
                } catch {
                    print("Error getting ticker from CoinMarketCap: ", error)
                }
                
                DispatchQueue.main.async {
                    completion(tickerResponse)
                }
            }
            task.resume()
        }
    }
    
    struct TickerResponse: Codable {
        let id: String?
        let name: String?
        let symbol: String?
        let priceUSD: Double?
        let priceBTC: Double?
        
        private enum CodingKeys: String, CodingKey {
            case id       = "id"
            case name     = "name"
            case symbol   = "symbol"
            case priceUSD = "price_usd"
            case priceBTC = "price_btc"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try? container.decode(String.self, forKey: .id)
            name = try? container.decode(String.self, forKey: .name)
            symbol = try? container.decode(String.self, forKey: .symbol)
            if let price_usd = try? container.decode(String.self, forKey: .priceUSD) {
                priceUSD = Double(price_usd)
            } else {
                priceUSD = nil
            }
            if let price_btc = try? container.decode(String.self, forKey: .priceBTC) {
                priceBTC = Double(price_btc)
            } else {
                priceBTC = nil
            }
        }
    }
}
