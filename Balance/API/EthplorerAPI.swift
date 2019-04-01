import CoreData
import Foundation

struct EthplorerAPI {
    private static let baseURL = URL(string: "https://api.ethplorer.io/")!
    private static let defaultApiKey = "freekey"
    private static let apiKey: String = {
        ApiKeys.ethplorerApiKey == "1" ? defaultApiKey : ApiKeys.ethplorerApiKey
    }()

    public static let isFreeApiKey: Bool = {
        apiKey == "freekey"
    }()

    static func loadWalletBalances(_ ethereumWallets: [EthereumWallet], completion: @escaping ([EthereumWallet]) -> Void) {
        DispatchQueue.utility.async {
            var returnWallets = [EthereumWallet]()
            let dispatchGroup = DispatchGroup()
            for ethereumWallet in ethereumWallets {
                dispatchGroup.enter()
                loadWalletBalance(ethereumWallet) { wallet, _ in
                    returnWallets.append(wallet)
                    dispatchGroup.leave()
                }

                // If we're using the free api key, serialize the api calls with a delay in between
                if isFreeApiKey {
                    dispatchGroup.wait()
                    Thread.sleep(forTimeInterval: 2.0)
                }
            }
            dispatchGroup.wait()

            // Sort the new array to match the original array
            var sortedReturnWallets = [EthereumWallet]()
            for ethereumWallet in ethereumWallets {
                if let returnWallet = returnWallets.first(where: { $0.address == ethereumWallet.address }) {
                    sortedReturnWallets.append(returnWallet)
                }
            }

            DispatchQueue.main.async {
                completion(sortedReturnWallets)
            }
        }
    }

    static func loadWalletBalance(_ ethereumWallet: EthereumWallet, completion: @escaping (EthereumWallet, Bool) -> Void) {
        DispatchQueue.utility.async {
            var addressInfoResponse: AddressInfoResponse?
            let urlPath = baseURL.appendingPathComponent("getAddressInfo").appendingPathComponent(ethereumWallet.address)
            var urlComponents = URLComponents(url: urlPath, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]
            guard let url = urlComponents?.url else {
                DispatchQueue.main.async {
                    completion(ethereumWallet, false)
                }
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }

                do {
                    addressInfoResponse = try JSONDecoder().decode(AddressInfoResponse.self, from: data)
                } catch {
                    print("Error getting address info for \(ethereumWallet.address): ", error)
                }

                // Convert to Balance model
                var returnWallet = ethereumWallet
                if let addressInfoResponse = addressInfoResponse, let ETH = addressInfoResponse.ETH {
                    returnWallet.balance = ETH.balance
                    if let tokensResponse = addressInfoResponse.tokens {
                        var tokens = [Token]()
                        for tokenInfoWrapper in tokensResponse {
                            let info = tokenInfoWrapper.tokenInfo
                            var decimalsInt: UInt?
                            if let decimalsString = info?.decimals {
                                decimalsInt = UInt(decimalsString)
                            }

                            var cryptoBalance: Double?
                            if let balance = tokenInfoWrapper.balance, let decimalsInt = decimalsInt {
                                cryptoBalance = balance / pow(10.0, Double(decimalsInt))
                            }

                            var fiatBalance: Double?
                            if let cryptoBalance = cryptoBalance, let rate = info?.price?.rate {
                                fiatBalance = cryptoBalance * rate
                            }

                            let token = Token(balance: cryptoBalance, fiatBalance: fiatBalance, rate: info?.price?.rate, currency: info?.price?.currency, address: info?.address, name: info?.name, symbol: info?.symbol, decimals: decimalsInt)
                            tokens.append(token)
                        }
                        returnWallet.tokens = tokens
                    }
                }

                DispatchQueue.main.async {
                    completion(returnWallet, true)
                }
            }
            task.resume()
        }
    }

    static func loadGetAddressInfo(_ ethereumWallets: [NSManagedObject], completion: @escaping ([AddressInfoResponse]) -> Void) {
        DispatchQueue.utility.async {
            let addresses = ethereumWallets.compactMap { maker in
                maker.value(forKey: "address") as? String
            }

            var addressInfoResponses = [AddressInfoResponse]()
            let dispatchGroup = DispatchGroup()
            for address in addresses {
                dispatchGroup.enter()
                loadGetAddressInfo(address: address) { response in
                    if let response = response {
                        addressInfoResponses.append(response)
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.wait()

            DispatchQueue.main.async {
                completion(addressInfoResponses)
            }
        }
    }

    static func loadGetAddressInfo(address: String, completion: @escaping (AddressInfoResponse?) -> Void) {
        DispatchQueue.utility.async {
            var addressInfoResponse: AddressInfoResponse?
            let urlPath = baseURL.appendingPathComponent("getAddressInfo").appendingPathComponent(address)
            var urlComponents = URLComponents(url: urlPath, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]
            guard let url = urlComponents?.url else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                }

                do {
                    addressInfoResponse = try JSONDecoder().decode(AddressInfoResponse.self, from: data)
                } catch {
                    print("Error getting address info for \(address): ", error)
                }

                DispatchQueue.main.async {
                    completion(addressInfoResponse)
                }
            }
            task.resume()
        }
    }

    struct AddressInfoResponse: Decodable {
        let address: String?
        let ETH: ETHResponse?
        let countTxs: UInt64?
        let tokens: [TokenInfoWrapperResponse]?
    }

    struct ETHResponse: Codable {
        let balance: Double?

        private enum CodingKeys: String, CodingKey {
            case balance
        }
    }

    struct TokenInfoWrapperResponse: Codable {
        let tokenInfo: TokenInfoResponse?
        let balance: Double?

        private enum CodingKeys: String, CodingKey {
            case tokenInfo
            case balance
        }
    }

    struct TokenInfoResponse: Codable {
        let address: String?
        let name: String?
        let decimals: String?
        let symbol: String?
        let totalSupply: String?
        let owner: String?
        let lastUpdated: UInt64?
        let issuancesCount: UInt64?
        let holdersCount: UInt64?
        let ethTransfersCount: UInt64?
        let price: PriceResponse?

        private enum CodingKeys: String, CodingKey {
            case address
            case name
            case decimals
            case symbol
            case totalSupply
            case owner
            case lastUpdated
            case issuancesCount
            case holdersCount
            case ethTransfersCount
            case price
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            address = try? container.decode(String.self, forKey: .address)
            name = try? container.decode(String.self, forKey: .name)
            decimals = try? container.decode(String.self, forKey: .decimals)
            symbol = try? container.decode(String.self, forKey: .symbol)
            totalSupply = try? container.decode(String.self, forKey: .totalSupply)
            owner = try? container.decode(String.self, forKey: .owner)
            lastUpdated = try? container.decode(UInt64.self, forKey: .lastUpdated)
            issuancesCount = try? container.decode(UInt64.self, forKey: .issuancesCount)
            holdersCount = try? container.decode(UInt64.self, forKey: .holdersCount)
            ethTransfersCount = try? container.decode(UInt64.self, forKey: .ethTransfersCount)

            // Handle possible boolean value in price field
            do {
                _ = try container.decode(Bool.self, forKey: .price)
                price = nil
            } catch {
                price = try? container.decode(PriceResponse.self, forKey: .price)
            }
        }
    }

    struct PriceResponse: Codable {
        let rate: Double?
        let diff: Double?
        let diff7d: Double?
        let ts: UInt64?
        let marketCapUsd: Double?
        let availableSupply: Double?
        let volume24h: Double?
        let diff30d: Double?
        let currency: String?

        private enum CodingKeys: String, CodingKey {
            case rate
            case diff
            case diff7d
            case ts
            case marketCapUsd
            case availableSupply
            case volume24h
            case diff30d
            case currency
        }
    }
}
