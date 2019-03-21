import UIKit
import SnapKit
import SwiftEntryKit

class WalletInfoView: UIView {
    private let wallet: EthereumWallet
    
    private let topContainer: UIView = {
        let topContainer = UIView()
        topContainer.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.16, alpha:1.0)
        topContainer.clipsToBounds = true
        topContainer.layer.cornerRadius = 20
        return topContainer
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18)
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
        return addressLabel
    }()
    
    private let bottomContainer: UIVisualEffectView = {
        let bottomContainer = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        bottomContainer.clipsToBounds = true
        bottomContainer.layer.cornerRadius = 20
        return bottomContainer
    }()
    
    private let shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.contentHorizontalAlignment = .left
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(UIColor(hexString: "#007AFF"), for: .normal)
        shareButton.setImage(UIImage(named: "shareButtonIcon"), for: .normal)
        return shareButton
    }()
    
    private let buttonSeparatorLine: UIView = {
        let buttonSeparatorLine = UIView()
        buttonSeparatorLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        return buttonSeparatorLine
    }()
    
    private let copyButton: UIButton = {
        let copyButton = UIButton()
        copyButton.contentHorizontalAlignment = .left
        copyButton.setTitle("Copy", for: .normal)
        copyButton.setTitleColor(UIColor(hexString: "#007AFF"), for: .normal)
        copyButton.setImage(UIImage(named: "copyButtonIcon"), for: .normal)
        copyButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        return copyButton
    }()

    init(wallet: EthereumWallet) {
        self.wallet = wallet
        super.init(frame: CGRect.zero)

        backgroundColor = .clear
        
        addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.height.equalTo(114)
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
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        shareButton.imageView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-21)
            make.centerY.equalToSuperview()
        }
        
        bottomContainer.contentView.addSubview(buttonSeparatorLine)
        buttonSeparatorLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        copyButton.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        bottomContainer.contentView.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        copyButton.imageView?.snp.makeConstraints { make in
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
        
        nameLabel.text = wallet.name
        topContainer.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        qrCodeImageView.image = QRCode.generate(fromString: wallet.address, size: 300)
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
        }
    }

    required init?(coder aDecoder: NSCoder) {
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
}
