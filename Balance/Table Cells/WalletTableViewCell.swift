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
            
            nameLabel.text = walletItem.name.count > 0 ? walletItem.name : "No Name"
            addressLabel.text = walletItem.address
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "walletCellBackground")?.stretchableImage(withLeftCapWidth: 20, topCapHeight: 20)
        return backgroundImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(hexString: "#fbfbfb")
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            // NOTE: Setting priority to less than 1000 on the top and bottom constraints prevents a constraint error when removing the cell
            make.top.equalToSuperview().offset(10).priority(999)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10).priority(999)
        }
        
        containerView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
