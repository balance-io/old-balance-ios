//
//  ArrayEthereumWallet+sort.swift
//  Balance
//
//  Created by Jamie Rumbelow on 28/04/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation

extension Array where Iterator.Element == EthereumWallet {
    // Sort an array of EthereumWallets, matching each element against another
    // array of EthereumWallets.
    func sort(byOrder orderedWallets: [EthereumWallet]) -> [EthereumWallet] {
        var sortedWallets = [EthereumWallet]()

        for wallet in orderedWallets {
            if let sortedWallet = self.first(where: { $0.address == wallet.address }) {
                sortedWallets.append(sortedWallet)
            }
        }

        return sortedWallets
    }
}
