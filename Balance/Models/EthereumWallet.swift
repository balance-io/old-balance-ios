import Foundation

struct EthereumWallet {
    struct Notifications {
        static let userOwnsBal = Notification.Name(rawValue: "EthereumWallet.userOwnsBal")
    }

    let name: String?
    let address: String
    let includeInTotal: Bool

    let symbol = "ETH"

    var balance: Double? // Balance in ETH
    var fiatBalance: Double? // Balance in fiat currency
    var rate: Double? // Price per unit in fiat currency
    var currency: String? // Fiat currency used for price and balance

    var tokens: [Token]?
    var valuableTokens: [Token]? {
        return tokens?.filter { ($0.fiatBalance ?? 0) >= Token.fiatValueCutoff }
    }

    var nonValuableTokens: [Token]? {
        return tokens?.filter { ($0.fiatBalance ?? 0) < Token.fiatValueCutoff }
    }

    var CDPs: [CDP]?

    init(name: String?, address: String, includeInTotal: Bool) {
        self.name = name
        self.address = address
        self.includeInTotal = includeInTotal

        balance = nil
        fiatBalance = nil
        rate = nil
        currency = nil

        tokens = nil
    }

    func pagingTabTitle() -> String {
        guard let name = name, !name.isEmpty else {
            return "0x.." + String(address[self.address.index(self.address.endIndex, offsetBy: -4)...])
        }

        return name
    }

    func isAlwaysExpanded() -> Bool {
        return valuableTokens?.isEmpty == true
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
                    if totalTokens.isEmpty {
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

                // Check for any BAL tokens; if we have some, let the rest of the app know.
                let balBalance: Double = totalTokens
                    .filter({ $0.symbol == "BAL" })
                    .reduce(0) { $0 + ($1.balance ?? 0) }

                if balBalance > 0 {
                    NotificationCenter.default.post(name: EthereumWallet.Notifications.userOwnsBal, object: nil, userInfo: ["total": balBalance])
                }

                if let CDPs = wallet.CDPs {
                    if totalCDPs.isEmpty {
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
