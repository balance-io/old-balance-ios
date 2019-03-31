import UIKit
import SnapKit

private let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter
}()

class CDPBalanceTableViewCell: UITableViewCell {
    var cdp: CDP? {
        didSet {
            guard let cdp = cdp else {
                return
            }
            
            if let id = cdp.id {
                identityLabel.text = "Ether #\(id)"
            }
            
            if let ratio = cdp.ratio {
                if ratio < 150.00 {
                    ratioLabel.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.5)
                } else if ratio < 200.00 {
                    ratioLabel.backgroundColor = .red
                } else if ratio < 250.00 {
                    ratioLabel.backgroundColor = .orange
                } else if ratio > 300.00 {
                    ratioLabel.backgroundColor = .green
                }
                ratioLabel.text = " \(String(format:"%.0f", ratio))%"
            }
            
            if let ink = cdp.ink {
                let collateral = ink
                let collateralFormatted = numberFormatter.string(from: NSNumber(value:collateral))
                inkLabel.text = "\(String(collateralFormatted!)) ETH"
            }

            if let art = cdp.art {
                let artFormatted = numberFormatter.string(from: NSNumber(value:art))
                artLabel.text = "\(artFormatted!) DAI"
            }
            
            if let liqPrice = cdp.liqPrice, let pip = cdp.pip {
                liqPriceLabel.text = "$\(String(format:"%.0f", pip)) · $\(String(format:"%.0f", liqPrice))"
            }
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
//        let darkCardBackgroundColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        view.layer.borderColor = UIColor(hexString: "#EEEEEE")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private let identityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hexString: "#6F6F6F")
        return label
    }()
    
    private let ethCircleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "eth"))
        imageView.frame = CGRect(x:0, y: 0, width: 30, height: 30)
        return imageView
    }()
    
    private let ratioLabel: UILabel = {
        let label = PaddedLabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.padding = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 4)
        label.textColor = UIColor(hexString: "#6F6F6F")
        label.clipsToBounds = true
        return label
    }()
    
    private let artLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        label.textColor = UIColor(hexString: "#6F6F6F")
        label.clipsToBounds = true
        return label
    }()
    
    private let inkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.textColor = UIColor(hexString: "#6F6F6F")
        label.clipsToBounds = true
        return label
    }()
    
    private let liqPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        label.textColor = UIColor(hexString: "#6F6F6F")
        label.clipsToBounds = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor(hexString: "#fbfbfb") // TODO - what does this set?
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        containerView.addSubview(ethCircleImageView)
        ethCircleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        containerView.addSubview(identityLabel)
        identityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(ethCircleImageView.snp.trailing).offset(10)
        }
        
        containerView.addSubview(inkLabel)
        inkLabel.snp.makeConstraints { make in
            make.top.equalTo(identityLabel.snp.bottom).offset(2)
            make.leading.equalTo(ethCircleImageView.snp.trailing).offset(10)
        }
        
        containerView.addSubview(liqPriceLabel)
        liqPriceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
//            make.centerY.equalTo(positionTitleLabel)
//            make.width.equalToSuperview().multipliedBy(0.55)
        }
        
        containerView.addSubview(artLabel)
        artLabel.snp.makeConstraints { make in
            make.top.equalTo(liqPriceLabel.snp.bottom).offset(2)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.55)
        }

        
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
}
