import UIKit
import SnapKit

class NamedWalletTableViewCell: WalletTableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Ethereum Wallet"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .black
        return label
    }()
    
    let walletTypeImageView: UIImageView = {
        let walletTypeImageView = UIImageView()
        walletTypeImageView.clipsToBounds = true
        return walletTypeImageView
    }()
    
    override func renderTableViewCellContentFor(containerView: UIView) {
        if (wallet != nil) {
            nameLabel.text = wallet!.name
        }

        containerView.addSubview(walletTypeImageView)
        walletTypeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        containerView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    override func walletWasSet(walletItem: EthereumWallet) {
        addressLabel.text = walletItem.address
        if walletItem.name == "" {
            nameLabel.text = "Ethereum Wallet"
        } else {
            nameLabel.text = walletItem.name
        }

        let walletName = walletItem.name

        if walletName!.lowercased().contains("metamask") {
            walletTypeImageView.image = UIImage(named: "metamask")
        } else if walletName!.lowercased().contains("ledger") {
            walletTypeImageView.image = UIImage(named: "ledger")
        } else if walletName!.lowercased().contains("trezor") {
            walletTypeImageView.image = UIImage(named: "trezor")
        } else if walletName!.lowercased().contains("trust") {
            walletTypeImageView.image = UIImage(named: "trust")
        } else if walletName!.lowercased().contains("imToken") {
            walletTypeImageView.image = UIImage(named: "imToken")
        } else {
            walletTypeImageView.image = UIImage(named: "noName")
        }
    }
}
