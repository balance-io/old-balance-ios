import Foundation
import CryptoSwift

public struct EIP55 {
    public static func test(_ address: String) -> Bool {
        guard address != "" else {
            return false
        }
        
        let checksumAddr = String(address.suffix(address.count - 2))
        let hash = SHA3(variant: .keccak256).calculate(for: Array(checksumAddr.lowercased().utf8))
        
        for i in 0..<checksumAddr.count {
            let charString = String(checksumAddr[checksumAddr.index(checksumAddr.startIndex, offsetBy: i)])
            if Int(charString) != nil {
                continue
            }
            
            let bytePos = (4 * i) / 8
            let bitPos = (4 * i) % 8
            
            guard bytePos < hash.count && bitPos < 8 else {
                return false
            }
            let bit = (hash[bytePos] >> (7 - UInt8(bitPos))) & 0x01
            
            if charString.lowercased() == charString && bit == 1 {
                return false
            } else if charString.uppercased() == charString && bit == 0 {
                return false
            }
        }
        
        return true
    }
}
