import Foundation
import web3

struct Web3 {
    private static let baseURL = URL(string: "https://mainnet.infura.io/v3/8f14a7a2d49f405db27d11bd6bbafdc7")!
    
    static func resolve(ensAddress: String, completion: @escaping (String?, EthereumNameServiceError?) -> ()) {
        let client = EthereumClient(url: baseURL)
        let ensService = EthereumNameService(client: client)
        DispatchQueue.userInitiated.async {
            ensService.resolve(ens: ensAddress) { error, address in
                DispatchQueue.main.async {
                    completion(address, error)
                }
            }
        }
    }
}
