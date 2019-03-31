import Foundation

struct Token {
    // Constant that defines the minimum fiat value to be considered a "valuable" token
    static let fiatValueCutoff = 10.0

    let balance: Double? // Balance in tokens
    let fiatBalance: Double? // Balance in fiat currency
    let rate: Double? // Price per unit in fiat currency
    let currency: String? // Fiat currency used for price and balance

    let address: String? // Contract address
    let name: String? // Token display name
    let symbol: String? // Token symbol
    let decimals: UInt? // Number of decimal places token can be broken down to

    func withAggregatedValuesFrom(token: Token) -> Token {
        var totalBalance = balance
        var totalFiatBalance = fiatBalance

        if let otherBalance = token.balance {
            if totalBalance == nil {
                totalBalance = otherBalance
            } else {
                totalBalance! += otherBalance
            }
        }

        if let otherFiatBalance = token.fiatBalance {
            if totalFiatBalance == nil {
                totalFiatBalance = otherFiatBalance
            } else {
                totalFiatBalance! += otherFiatBalance
            }
        }

        return Token(balance: totalBalance, fiatBalance: totalFiatBalance, rate: rate, currency: currency, address: address, name: name, symbol: symbol, decimals: decimals)
    }
}
