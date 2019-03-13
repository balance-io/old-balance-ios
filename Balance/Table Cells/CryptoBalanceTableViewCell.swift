//
//  CryptoBalanceTableViewCell.swift
//  Balance
//
//  Created by Benjamin Baron on 3/12/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

class CryptoBalanceTableViewCell: UITableViewCell {
    enum CryptoType {
        case ethereum
        case erc20
    }
    
    let cryptoType: CryptoType
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(hexString: "#EEEEEE")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let titleIconView: UIImageView = {
        let titleIconView = UIImageView()
        titleIconView.translatesAutoresizingMaskIntoConstraints = false
        return titleIconView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor(hexString: "#333333")
        return titleLabel
    }()
    
    init(wallet: EthereumWallet, cryptoType: CryptoType) {
        self.cryptoType = cryptoType
        super.init(style: .default, reuseIdentifier: "cryptoCell")
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor(hexString: "#fbfbfb")
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.addSubview(titleIconView)
        titleIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(14)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleIconView.snp.trailing).offset(10)
            make.centerY.equalTo(titleIconView)
        }
        
        switch cryptoType {
        case .ethereum:
            titleIconView.image = UIImage(named: "ethSquircleDark")
            titleLabel.text = "Ethereum"
        case .erc20:
            titleIconView.image = UIImage(named: "erc20SquircleGreen")
            titleLabel.text = "ERC-20 Tokens"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
}
