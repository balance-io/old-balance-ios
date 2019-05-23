import CoreData
import Foundation

struct MakerToolsAPI {
    private static let ethBaseURL = URL(string: "https://mkr.tools/api/v1/lad/")!

    static func loadEthereumWalletCDPs(_ ethereumWallets: [EthereumWallet], completion: @escaping ([EthereumWallet]) -> Void) {
        let ids = ethereumWallets.compactMap { wallet in
            wallet.address
        }

        loadCDPs(ids: ids, baseURL: ethBaseURL) { CDPsDict in
            var returnWallets = [EthereumWallet]()
            for ethereumWallet in ethereumWallets {
                let returnWallet = ethereumWallet
                returnWallet.CDPs = CDPsDict[ethereumWallet.address]
                returnWallets.append(returnWallet)
            }

            completion(returnWallets)
        }
    }

    private static func loadCDPs(ids: [String], baseURL: URL, completion: @escaping ([String: [CDP]]) -> Void) {
        DispatchQueue.utility.async {
            var CDPs = [String: [CDP]]()
            let dispatchGroup = DispatchGroup()
            for id in ids {
                dispatchGroup.enter()
                let url = baseURL.appendingPathComponent(id)
                let task = URLSession.shared.dataTask(with: url) { data, _, error in
                    defer {
                        dispatchGroup.leave()
                    }

                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                    }

                    do {
                        let loadedCDPs = try JSONDecoder().decode([CDP].self, from: data)
                        CDPs[id] = loadedCDPs
                    } catch {
                        print("Error", error)
                    }
                }
                task.resume()
            }

            dispatchGroup.wait()
            DispatchQueue.main.async {
                completion(CDPs)
            }
        }
    }
}
