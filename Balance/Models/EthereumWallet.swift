import Foundation

struct EthereumWallet {
    let name: String?
    let address: String
    let includeInTotal: Bool

    let symbol = "ETH"

    var balance: Double?     // Balance in ETH
    var fiatBalance: Double? // Balance in fiat currency
    var rate: Double?       // Price per unit in fiat currency
    var currency: String?    // Fiat currency used for price and balance

    var tokens: [Token]?
    var valuableTokens: [Token]? {
        return tokens?.filter{ $0.fiatBalance ?? 0 >= Token.fiatValueCutoff }
    }
    var nonValuableTokens: [Token]? {
        return tokens?.filter{ $0.fiatBalance ?? 0 < Token.fiatValueCutoff }
    }

    var CDPs: [CDP]?

    init(name: String?, address: String, includeInTotal: Bool) {
        self.name = name
        self.address = address
        self.includeInTotal = includeInTotal

        self.balance = nil
        self.fiatBalance = nil
        self.rate = nil
        self.currency = nil

        self.tokens = nil
    }

    func pagingTabTitle() -> String {
        guard let name = name, name.count > 0 else {
            return "0x.." + String(self.address[self.address.index(self.address.endIndex, offsetBy: -4)...])
        }

        return name
    }

    static func aggregated(wallets: [EthereumWallet]) -> EthereumWallet? {
        // Aggregate the balances
        // NOTE: This currently assumes all wallets have the same fiat currency
        var aggregatedEthereumWallet: EthereumWallet?
        if wallets.count == 1 {
            // There's only one wallet, so just use that
            aggregatedEthereumWallet = wallets[0]
        } else {
            // Combine all of the balances
            aggregatedEthereumWallet = EthereumWallet(name: "___Aggregated___", address: "", includeInTotal: false)
            aggregatedEthereumWallet?.rate = wallets[0].rate
            aggregatedEthereumWallet?.currency = wallets[0].currency
            var totalBalance: Double = 0
            var totalFiatBalance: Double = 0
            var totalTokens = [Token]()
            var totalCDPs = [CDP]()
            for wallet in wallets {
                if let balance = wallet.balance {
                    totalBalance += balance
                }

                if let fiatBalance = wallet.fiatBalance {
                    totalFiatBalance += fiatBalance
                }

                if let tokens = wallet.tokens {
                    if totalTokens.count == 0 {
                        totalTokens = tokens
                    } else {
                        var tempTotalTokens = [Token]()
                        for token in tokens {
                            if let existingToken = totalTokens.first(where: { $0.address == token.address }) {
                                tempTotalTokens.append(existingToken.withAggregatedValuesFrom(token: token))
                            } else {
                                tempTotalTokens.append(token)
                            }
                        }

                        // Add back any missing tokens
                        for existingToken in totalTokens {
                            if tempTotalTokens.first(where: { $0.address == existingToken.address }) == nil {
                                tempTotalTokens.append(existingToken)
                            }
                        }
                        totalTokens = tempTotalTokens
                    }
                }

                if let CDPs = wallet.CDPs {
                    if totalCDPs.count == 0 {
                        totalCDPs = CDPs
                    } else {
                        for cdp in CDPs {
                            if !totalCDPs.contains(where: { $0.id == cdp.id }) {
                                totalCDPs.append(cdp)
                            }
                        }
                    }
                }
            }
            aggregatedEthereumWallet?.balance = totalBalance
            aggregatedEthereumWallet?.fiatBalance = totalFiatBalance
            aggregatedEthereumWallet?.tokens = totalTokens
            aggregatedEthereumWallet?.CDPs = totalCDPs
        }
        return aggregatedEthereumWallet
    }
}
