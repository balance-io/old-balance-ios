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
                identityLabel.text = "Maker CDP #\(id)"
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
            
            if let ink = cdp.ink, let pip = cdp.pip {
                let collateral = ink * pip
                let collateralFormatted = numberFormatter.string(from: NSNumber(value:collateral))
                inkLabel.text = "\(String(collateralFormatted!)) USD"
            }

            if let art = cdp.art {
                let artFormatted = numberFormatter.string(from: NSNumber(value:art))
                artLabel.text = "\(artFormatted!) DAI"
            }
            
            if let liqPrice = cdp.liqPrice, let pip = cdp.pip {
                liqPriceLabel.text = "$\(String(format:"%.0f", pip)) / \(String(format:"%.0f", liqPrice))"
            }
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        let darkCardBackgroundColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        view.backgroundColor = darkCardBackgroundColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let identityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let ethCircleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ethWhiteCircle"))
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        return imageView
    }()
    
    private let mkrSquircle: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "mkrSquircle"))
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        return imageView
    }()
    
    private let daiCircle: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "daiCircle"))
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        return imageView
    }()
    
    private let checkCircle: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkCircle"))
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        return imageView
    }()
    
    private let collateralizedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Collateral"
        label.textColor = .white
        return label
    }()
    
    private let debtTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Debt"
        label.textColor = .white
        return label
    }()
    
    private let positionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Position"
        label.textColor = .white
        return label
    }()
    
    private let ratioLabel: UILabel = {
        let label = PaddedLabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.padding = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 4)
        label.textColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    private let artLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    private let inkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    private let liqPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor(hexString: "#fbfbfb")
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }

        containerView.addSubview(mkrSquircle)
        mkrSquircle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(15)
        }
        
        containerView.addSubview(identityLabel)
        identityLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mkrSquircle)
            make.leading.equalTo(mkrSquircle.snp.trailing).offset(5)
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        containerView.addSubview(ratioLabel)
        ratioLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(identityLabel)
            make.width.equalToSuperview().multipliedBy(0.17)
        }
        
        containerView.addSubview(ethCircleImageView)
        ethCircleImageView.snp.makeConstraints { make in
            make.top.equalTo(mkrSquircle.snp.bottom).offset(12)
            make.centerX.equalTo(mkrSquircle)
        }
        
        containerView.addSubview(collateralizedTitleLabel)
        collateralizedTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ethCircleImageView)
            make.leading.equalTo(ethCircleImageView.snp.trailing).offset(5)
        }

        containerView.addSubview(inkLabel)
        inkLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(collateralizedTitleLabel)
            make.width.equalToSuperview().multipliedBy(0.55)
        }
        
        containerView.addSubview(daiCircle)
        daiCircle.snp.makeConstraints { make in
            make.top.equalTo(ethCircleImageView.snp.bottom).offset(12)
            make.centerX.equalTo(ethCircleImageView)
        }

        containerView.addSubview(debtTitleLabel)
        debtTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(daiCircle)
            make.leading.equalTo(collateralizedTitleLabel)
        }

        containerView.addSubview(artLabel)
        artLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(debtTitleLabel)
            make.width.equalToSuperview().multipliedBy(0.55)
        }
        
        containerView.addSubview(checkCircle)
        checkCircle.snp.makeConstraints { make in
            make.top.equalTo(daiCircle.snp.bottom).offset(12)
            make.centerX.equalTo(ethCircleImageView)
        }
        
        containerView.addSubview(positionTitleLabel)
        positionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(checkCircle)
            make.leading.equalTo(debtTitleLabel)
        }
        
        containerView.addSubview(liqPriceLabel)
        liqPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(positionTitleLabel)
            make.width.equalToSuperview().multipliedBy(0.55)
        }
        
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
}
