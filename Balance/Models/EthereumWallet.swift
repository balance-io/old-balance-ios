import Foundation

struct EthereumWallet {
    let name: String
    let address: String
    let includeInTotal: Bool
    
    var balance: Double?
    var price: Double?
    var currency: String?
    
    var tokens: [Token]?
    
    init(name: String, address: String, includeInTotal: Bool) {
        self.name = name
        self.address = address
        self.includeInTotal = includeInTotal
        
        self.balance = nil
        self.price = nil
        self.currency = nil
        
        self.tokens = nil
    }
}
