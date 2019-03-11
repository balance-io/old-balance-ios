//
//  CDPTableViewCell.swift
//  Balance
//
//  Created by Richard Burton on 21/02/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit
import SnapKit

class WalletTableViewCell: UITableViewCell {
    var wallet: EthereumWallet? {
        didSet {
            guard let walletItem = wallet else {
                return
            }
            
            if let name = walletItem.name {
                nameLabel.text = "\(name)"
            } else {
                nameLabel.text = "No Name"
            }
            
            if let address = walletItem.address {
                addressLabel.text = "\(address)"
            }
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            // NOTE: Setting priority to less than 1000 on the top and bottom constraints prevents a constraint error when removing the cell
            make.top.equalToSuperview().offset(10).priority(999)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10).priority(999)
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
        
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView?.backgroundColor = selected ? .red : nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
}
