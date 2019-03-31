import SnapKit
import UIKit

class NamedWalletTableViewCell: WalletTableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Ethereum Wallet"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor(hexString: "#131415")
        return label
    }()

    let walletTypeImageView: UIImageView = {
        let walletTypeImageView = UIImageView()
        walletTypeImageView.clipsToBounds = true
        return walletTypeImageView
    }()

    override func renderTableViewCellContentFor(containerView: UIView) {
        if wallet != nil {
            nameLabel.text = wallet!.name
        }

        containerView.addSubview(walletTypeImageView)
        walletTypeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
        }

        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(15)
            make.centerY.equalTo(walletTypeImageView)
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalToSuperview().offset(-15)
        }

        containerView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }

    override func walletWasSet(walletItem: EthereumWallet) {
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

        let firstFour = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#131415"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
        ]
        let middle = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#515459"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light),
        ]
        let lastFour = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#131415"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
        ]

        let partOne = NSMutableAttributedString(string: "\(String(walletItem.address.prefix(4)))", attributes: firstFour as [NSAttributedString.Key: Any])
        let partTwo = NSMutableAttributedString(string: "\(String(walletItem.address.dropFirst(4).dropLast(4)))", attributes: middle as [NSAttributedString.Key: Any])
        let partThree = NSMutableAttributedString(string: "\(String(walletItem.address.suffix(4)))", attributes: lastFour as [NSAttributedString.Key: Any])

        let combination = NSMutableAttributedString()

        combination.append(partOne)
        combination.append(partTwo)
        combination.append(partThree)

        addressLabel.attributedText = combination
    }
}
