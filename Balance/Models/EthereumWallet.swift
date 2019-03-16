import Foundation

struct EthereumWallet {
    let name: String
    let address: String
    let includeInTotal: Bool
    
    let symbol = "ETH"
    
    var balance: Double?     // Balance in ETH
    var fiatBalance: Double? // Balance in fiat currency
    var rate: Double?       // Price per unit in fiat currency
    var currency: String?    // Fiat currency used for price and balance
    
    var tokens: [Token]?
    var nonZeroTokens: [Token]? {
        return tokens?.filter{
            if let fiat = $0.fiatBalance {
                return fiat >= 10.0
            }
            return false
        }
    }
    
    init(name: String, address: String, includeInTotal: Bool) {
        self.name = name
        self.address = address
        self.includeInTotal = includeInTotal
        
        self.balance = nil
        self.fiatBalance = nil
        self.rate = nil
        self.currency = nil
        
        self.tokens = nil
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
            }
            aggregatedEthereumWallet?.balance = totalBalance
            aggregatedEthereumWallet?.fiatBalance = totalFiatBalance
            aggregatedEthereumWallet?.tokens = totalTokens
        }
        return aggregatedEthereumWallet
    }
}
