//
//  AmberdataAPI.swift
//  Balance
//
//  Created by Jamie Rumbelow on 28/04/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import CoreData
import Foundation

struct AmberdataAPI {
    static func loadWalletBalances(_ ethereumWallets: [EthereumWallet], completion: @escaping ([EthereumWallet]) -> Void) {
        DispatchQueue.utility.async {
            let dispatchGroup = DispatchGroup()
            var returnWallets = [EthereumWallet]()

            for ethereumWallet in ethereumWallets {
                dispatchGroup.enter()
                loadWalletBalance(ethereumWallet) { wallet, _ in
                    returnWallets.append(wallet)
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.wait()

            // Sort the new array to match the original array
            let sortedReturnWallets = returnWallets.sort(byOrder: ethereumWallets)

            DispatchQueue.main.async {
                completion(sortedReturnWallets)
            }
        }
    }

    static func loadWalletBalance(_ ethereumWallet: EthereumWallet, completion: @escaping (EthereumWallet, Bool) -> Void) {
        DispatchQueue.utility.async {
            let dispatchGroup = DispatchGroup()
            let returnWallet = ethereumWallet

            loadWalletEthBalance(returnWallet, withinDispatchGroup: dispatchGroup)
            loadWalletTokens(returnWallet, withinDispatchGroup: dispatchGroup)

            dispatchGroup.wait()

            DispatchQueue.main.async {
                completion(returnWallet, true)
            }
        }
    }

    static func loadWalletEthBalance(_ wallet: EthereumWallet, withinDispatchGroup dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()

        AmberdataRequest(fromComponents: ["addresses", wallet.address, "account-balances", "latest"])
            .withQueryStringComponents(["includePrice": "true"])
            .go { data in

                let accountBalanceResponse: AmberdataAccountBalanceResponse

                do {
                    accountBalanceResponse = try JSONDecoder().decode(AmberdataAccountBalanceResponse.self, from: data)
                } catch {
                    print("JSON error: \(error)")
                    return
                }

                if let value = accountBalanceResponse.payload?.value, let weiValue = Int(value) {
                    wallet.updateBalance(fromWei: weiValue)
                }

                dispatchGroup.leave()
            }
    }

    static func loadWalletTokens(_ wallet: EthereumWallet, withinDispatchGroup dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()

        AmberdataRequest(fromComponents: ["addresses", wallet.address, "tokens"])
            .withQueryStringComponents(["includePrice": "true"])
            .go { data in

                let tokensResponse: AmberdataTokensResponse

                do {
                    tokensResponse = try JSONDecoder().decode(AmberdataTokensResponse.self, from: data)
                } catch {
                    print("JSON error: \(error)")
                    return
                }

                guard let records = tokensResponse.payload?.records else {
                    dispatchGroup.leave()
                    return
                }

                wallet.tokens = records.map { tokenInfo in
                    var balance: Double?
                    var fiatBalance: Double?
                    var rate: Double?
                    var currency: String?

                    if let amount = tokenInfo.price?.amount {
                        fiatBalance = amount.total
                        rate = amount.quote
                        currency = amount.currency
                    }

                    if let amount = tokenInfo.amount, let decimals = tokenInfo.decimals {
                        balance = Double(amount) * pow(10.0, 0.0 - Double(decimals))
                    }

                    return Token(balance: balance,
                                 fiatBalance: fiatBalance,
                                 rate: rate,
                                 currency: currency,
                                 address: tokenInfo.address,
                                 name: tokenInfo.name,
                                 symbol: tokenInfo.symbol,
                                 decimals: tokenInfo.decimals)
                }

                dispatchGroup.leave()
            }
    }
}

// MARK: - General Request Handling

struct AmberdataRequest {
    static let baseURL = URL(string: "https://web3api.io/api/v1/")!
    static let apiKey: String = ApiKeys.amberdataApiKey

    var request: URLRequest

    init(fromRequest request: URLRequest) {
        self.request = request
    }

    init(fromComponents components: [String]) {
        let requestUrl = components.reduce(AmberdataRequest.baseURL) { url, component in
            url.appendingPathComponent(component)
        }

        request = URLRequest(url: requestUrl)
        request.setValue(AmberdataRequest.apiKey, forHTTPHeaderField: "x-api-key")
    }

    func withQueryStringComponents(_ components: [String: String]) -> AmberdataRequest {
        var request = self.request

        guard let url = request.url else {
            return self
        }

        request.url = components.reduce(url) { (url: URL, keyValue: (String, String)) in
            url.appendingQueryStringComponent(keyValue.0, value: keyValue.1)
        }

        return AmberdataRequest(fromRequest: request)
    }

    func go(completion: @escaping (Data) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, let response = response as? HTTPURLResponse else {
                print(error ?? "Response Error")
                return
            }

            guard (200 ... 299).contains(response.statusCode) else {
                print(response)
                return
            }

            completion(data)
        }

        task.resume()
    }
}

// MARK: - Decodable Types

private struct AmberdataAccountBalanceResponse: Decodable {
    let title, description: String?
    let payload: AccountBalance?
    let status: Int?
}

private struct AmberdataTokensResponse: Decodable {
    let status: Int?
    let title, description: String?
    let payload: Tokens?
}

private struct AccountBalance: Decodable {
    let address: String?
    let value: String?
    let price: AccountBalancePrice?
}

// Urgh. Account balance is nested: { ... price: { value: ... } } whereas the tokens
// request is nested: { ... price: { amount: ... } }. So we need to unmarshall into
// two different, but structurally identical, objects.

private struct AccountBalancePrice: Decodable {
    let value: PriceValue?
}

private struct TokensPrice: Decodable {
    let amount: PriceValue?
}

private struct PriceValue: Decodable {
    var currency: String?
    var quote, total: Double?

    enum CodingKeys: String, CodingKey {
        case currency, quote, total
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        currency = try container.decode(String.self, forKey: .currency)
        quote = Double(try container.decode(String.self, forKey: .quote))
        total = Double(try container.decode(String.self, forKey: .total))
    }
}

private struct Tokens: Decodable {
    var records: [TokenInfo]
    var totalRecords: UInt

    enum CodingKeys: String, CodingKey {
        case records, totalRecords
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        records = try container.decode([TokenInfo].self, forKey: .records)

        if let records = try? container.decode(Int.self, forKey: .totalRecords) {
            totalRecords = UInt(records)
        } else {
            totalRecords = UInt(try container.decode(String.self, forKey: .totalRecords)) ?? 0
        }
    }
}

private struct TokenInfo: Decodable {
    var address, holder, name, symbol: String?

    var amount: UInt?
    var decimals: UInt?
    var isERC20, isERC721, isERC777, isERC884, isERC998: Bool?
    var price: TokensPrice?

    enum CodingKeys: String, CodingKey {
        case address, holder, amount, decimals, name, symbol, isERC20, isERC721, isERC777, isERC884, isERC998, price
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        address = try? container.decode(String.self, forKey: .address)
        holder = try? container.decode(String.self, forKey: .holder)
        amount = UInt(try container.decode(String.self, forKey: .amount)) ?? 0
        decimals = UInt(try container.decode(String.self, forKey: .decimals)) ?? 0
        name = try? container.decode(String.self, forKey: .name)
        symbol = try? container.decode(String.self, forKey: .symbol)
        isERC20 = try? container.decode(Bool.self, forKey: .isERC20)
        isERC721 = try? container.decode(Bool.self, forKey: .isERC721)
        isERC777 = try? container.decode(Bool.self, forKey: .isERC777)
        isERC884 = try? container.decode(Bool.self, forKey: .isERC884)
        isERC998 = try? container.decode(Bool.self, forKey: .isERC998)
        price = try? container.decode(TokensPrice.self, forKey: .price)
    }
}
