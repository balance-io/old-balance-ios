import UIKit

class EthereumTableViewCell: UITableViewCell {
//    var wallet:EthereumWallet? {
//        didSet {
//            guard let walletItem = wallet else {return}
//
//            if let name = walletItem.name {
//                nameLabel.text = "\(String(name))"
//            } else {
//                nameLabel.text = "No Name"
//            }
//
//            if let address = walletItem.address {
//                addressLabel.text = "\(String(address))"
//            }
//        }
//    }

    let ethSquircleImageView: UIImageView = {
        let image = UIImage(named: "ethSquircleDark")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let ethereumLabel: UILabel = {
        let label = UILabel()
        label.text = "Ethereum"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // TODO: add WETH | PETH

    let lineView: UIView = {
        let line = UIView(frame: CGRect())
        line.backgroundColor = .white
        line.alpha = 0.8
        line.layer.cornerRadius = 5

        return line
    }()

    let ethCircleImageView: UIImageView = {
        let image = UIImage(named: "ethWhiteCircle")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let ethAmountsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "33 ETH × 150 USD"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()

    let ethDollarTotal: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "$4,950"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()

    let containerView: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        containerView.addSubview(ethSquircleImageView)
        containerView.addSubview(ethereumLabel)
        containerView.addSubview(lineView)
        containerView.addSubview(ethCircleImageView)
        containerView.addSubview(ethAmountsLabel)
        containerView.addSubview(ethDollarTotal)

        contentView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)

        contentView.addSubview(containerView)

        ethSquircleImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(10)
            make.left.equalTo(containerView).offset(10)
        }

        ethereumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ethSquircleImageView)
            make.left.equalTo(ethSquircleImageView.snp_rightMargin).offset(10)
        }

        // TODO: Autolayout for full cell

        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedBackgroundView!.backgroundColor = selected ? .red : nil
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
