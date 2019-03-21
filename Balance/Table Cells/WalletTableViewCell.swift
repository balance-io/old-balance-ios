//
//  UnnamedWalletTableViewCell.swift
//  Balance
//
//  Created by Jamie Rumbelow on 20/03/2019.
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

            walletWasSet(walletItem: walletItem)
        }
    }

    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()

    let containerView: UIView = {
        let view = UIView()
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

        self.renderTableViewCellContentFor(containerView: containerView)

        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
    }

    internal func renderTableViewCellContentFor(containerView: UIView) {
        fatalError("unimplemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView?.backgroundColor = selected ? .red : nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }

    internal func walletWasSet(walletItem: EthereumWallet) {
        addressLabel.text = walletItem.address
    }
}
