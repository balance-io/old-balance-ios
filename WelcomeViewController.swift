import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    private let balanceLogoImageView: UIImageView = {
        let balanceLogoImageView = UIImageView()
        balanceLogoImageView.image = UIImage(named: "balanceLogo")
        return balanceLogoImageView
    }()
    
    private let wavesAndLogosImageView: UIImageView = {
        let wavesAndLogosImageView = UIImageView()
        wavesAndLogosImageView.image = UIImage(named: "wavesAndLogos")
        return wavesAndLogosImageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = UIColor(hexString: "#191817")
        titleLabel.text = "Keep track of your wallets"
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 17)
        subtitleLabel.textColor = UIColor(hexString: "#191817")
        subtitleLabel.numberOfLines = 3
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Add an address to see all of your Ether, ERC-20 tokens, and Maker CDPs in one place on your phone."
        return subtitleLabel
    }()
    
    private let addButton: UIButton = {
        let addButton = UIButton()
        addButton.layer.cornerRadius = 14
        addButton.setTitle("Add an Ethereum Wallet", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.setBackgroundImage(UIImage(named: "blueGradientButton"), for: .normal)
        addButton.setImage(UIImage(named: "ethLogoWhite"), for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return addButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "#FBFBFB")
        
        view.addSubview(balanceLogoImageView)
        balanceLogoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(wavesAndLogosImageView)
        wavesAndLogosImageView.snp.makeConstraints { make in
            make.top.equalTo(balanceLogoImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(80)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-15)
            make.height.equalTo(95)
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
        }
        addButton.imageView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview().offset(-2)
        }
        addButton.titleEdgeInsets = UIEdgeInsets(top: -2, left: -20, bottom: 0, right: 0)
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
    }
    
    @objc private func addAction() {
        let addEthereumWalletViewController = AddEthereumWalletViewController()
        present(addEthereumWalletViewController, animated: true)
    }
}
