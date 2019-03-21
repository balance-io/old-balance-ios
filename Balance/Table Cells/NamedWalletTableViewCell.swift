//
//  UnnamedWalletTableViewCell.swift
//  Balance
//
//  Created by Jamie Rumbelow on 20/03/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit
import SnapKit

class NamedWalletTableViewCell: WalletTableViewCell {
    internal let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override internal func renderTableViewCellContentFor(containerView: UIView) {
        if (wallet != nil) {
            nameLabel.text = wallet!.name
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        containerView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel)
        }
    }
    
    override internal func walletWasSet(walletItem: EthereumWallet) {
        addressLabel.text = walletItem.address
        nameLabel.text = walletItem.name
    }
}
