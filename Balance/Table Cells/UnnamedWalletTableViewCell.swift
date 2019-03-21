//
//  UnnamedWalletTableViewCell.swift
//  Balance
//
//  Created by Jamie Rumbelow on 20/03/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit
import SnapKit

class UnnamedWalletTableViewCell: WalletTableViewCell {
    override internal func renderTableViewCellContentFor(containerView: UIView) {
        containerView.addSubview(addressLabel)
        addressLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
