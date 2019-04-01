import SnapKit
import SwiftEntryKit
import UIKit

private func newSeparatorLine() -> UIView {
    let buttonSeparatorLine = UIView()
    buttonSeparatorLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    return buttonSeparatorLine
}

private func createButton(withTitle title: String, andImageName imageName: String) -> UIButton {
    let newButton = UIButton()
    newButton.contentHorizontalAlignment = .left
    newButton.setTitle(title, for: .normal)
    newButton.setTitleColor(UIColor(hexString: "#007AFF"), for: .normal)
    newButton.setImage(UIImage(named: imageName), for: .normal)
    return newButton
}

class WalletInfoView: UIView {
    private let wallet: EthereumWallet
    private var updateWalletName: ((String) -> Void)?

    private let closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "xWhite"), for: .normal)
        return closeButton
    }()

    private let topContainer: UIView = {
        let topContainer = UIView()
        topContainer.backgroundColor = UIColor(red: 0.11, green: 0.13, blue: 0.16, alpha: 1.0)
        topContainer.clipsToBounds = true
        topContainer.layer.cornerRadius = 20
        return topContainer
    }()

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        nameLabel.text = "Ethereum Wallet"
        nameLabel.textColor = .white
        return nameLabel
    }()

    private let qrCodeImageView: UIImageView = {
        let qrCodeImageView = UIImageView()
        qrCodeImageView.clipsToBounds = true
        qrCodeImageView.layer.cornerRadius = 10
        return qrCodeImageView
    }()

    private let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        addressLabel.textColor = .white
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.minimumScaleFactor = 0.3
        addressLabel.numberOfLines = 1
        return addressLabel
    }()

    private let bottomContainer: UIVisualEffectView = {
        let bottomContainer = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        bottomContainer.clipsToBounds = true
        bottomContainer.layer.cornerRadius = 20
        return bottomContainer
    }()

    private let shareButton: UIButton = createButton(withTitle: "Share", andImageName: "shareButtonIcon")
    private let copyButton: UIButton = createButton(withTitle: "Copy", andImageName: "copyButtonIcon")
    private let editWalletNameButton: UIButton = createButton(withTitle: "Edit Wallet Name", andImageName: "copyButtonIcon")

    private let buttonSeparatorLine1: UIView = newSeparatorLine()
    private let buttonSeparatorLine2: UIView = newSeparatorLine()

    init(wallet: EthereumWallet, updateHandler handler: @escaping (String) -> Void) {
        self.wallet = wallet
        updateWalletName = handler

        super.init(frame: CGRect.zero)

        backgroundColor = .clear

        addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.height.equalTo(171)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        bottomContainer.contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        shareButton.imageView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-21)
            make.centerY.equalToSuperview()
        }

        bottomContainer.contentView.addSubview(buttonSeparatorLine1)
        buttonSeparatorLine1.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(shareButton.snp.bottom)
        }

        copyButton.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        bottomContainer.contentView.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(buttonSeparatorLine1.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        copyButton.imageView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
        }

        bottomContainer.contentView.addSubview(buttonSeparatorLine2)
        buttonSeparatorLine2.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(copyButton.snp.bottom)
        }

        editWalletNameButton.addTarget(self, action: #selector(editWalletNameAction), for: .touchUpInside)
        bottomContainer.contentView.addSubview(editWalletNameButton)
        editWalletNameButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(buttonSeparatorLine2.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        editWalletNameButton.imageView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        topContainer.addGestureRecognizer(tapGestureRecognizer)
        addSubview(topContainer)
        topContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(bottomContainer.snp.top).offset(-30)
        }

        topContainer.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        // TODO: Fix this cheeky hack
        if (wallet.name?.isEmpty)! {
            nameLabel.text = "Ethereum Wallet"
        } else {
            nameLabel.text = wallet.name
        }

        topContainer.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(closeButton.snp.leading).offset(-10)
        }

        qrCodeImageView.image = QRCode.generate(fromString: "ethereum:\(wallet.address)", size: 300)
        topContainer.addSubview(qrCodeImageView)
        qrCodeImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(qrCodeImageView.snp.width)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        addressLabel.text = wallet.address
        topContainer.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(qrCodeImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalTo(qrCodeImageView)
            make.trailing.equalTo(qrCodeImageView)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("unimplemented")
    }

    // MARK: - Actions -

    @objc private func tapAction() {
        SwiftEntryKit.dismiss()
    }

    @objc private func shareAction() {
        let activityViewController = UIActivityViewController(activityItems: [wallet.address], applicationActivities: nil)
        let rootViewController = AppDelegate.shared.window.rootViewController
        rootViewController?.present(activityViewController, animated: true, completion: nil)
        SwiftEntryKit.dismiss()
    }

    @objc private func copyAction() {
        UIPasteboard.general.string = wallet.address
        SwiftEntryKit.dismiss()
    }

    @objc private func editWalletNameAction() {
        let alertController = UIAlertController(title: "Edit Wallet Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            if (self.wallet.name?.isEmpty)! {
                textField.text = "Ethereum Wallet"
            } else {
                textField.text = self.wallet.name
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned alertController] _ in
            let answer = alertController.textFields![0]
            if let handler = self.updateWalletName {
                handler(answer.text!)
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        let rootViewController = AppDelegate.shared.window.rootViewController
        rootViewController?.present(alertController, animated: true, completion: nil)

        SwiftEntryKit.dismiss()
    }
}
