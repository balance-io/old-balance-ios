import SnapKit
import UIKit

private let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter
}()

class CDPBalanceTableViewCell: UITableViewCell {
    var cdp: CDP? {
        didSet {
            guard let cdp = cdp else {
                return
            }

            if let id = cdp.id {
                let cryptoAmountAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
                let cryptoSymbolAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]

                let partOne = NSMutableAttributedString(string: "Ether", attributes: cryptoAmountAttributes)
                let partTwo = NSMutableAttributedString(string: " #\(id)", attributes: cryptoSymbolAttributes)

                let combination = NSMutableAttributedString()

                combination.append(partOne)
                combination.append(partTwo)

                identityLabel.attributedText = combination
            }

            // TODO: look into more elegant way of doing this
            // http://danielemargutti.com/2016/12/04/attributed-string-in-swift-the-right-way/

            if let ink = cdp.ink {
                let collateral = ink
                let collateralFormatted = numberFormatter.string(from: NSNumber(value: collateral))

                let cryptoAmountAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
                let cryptoSymbolAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]

                let partOne = NSMutableAttributedString(string: "\(String(collateralFormatted!))", attributes: cryptoAmountAttributes)
                let partTwo = NSMutableAttributedString(string: " ETH", attributes: cryptoSymbolAttributes)

                let combination = NSMutableAttributedString()

                combination.append(partOne)
                combination.append(partTwo)

                inkLabel.attributedText = combination
            }

            if let art = cdp.art {
                let artFormatted = numberFormatter.string(from: NSNumber(value: art))

                let cryptoAmountAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
                let cryptoSymbolAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]

                let partOne = NSMutableAttributedString(string: "\(artFormatted!)", attributes: cryptoAmountAttributes)
                let partTwo = NSMutableAttributedString(string: " DAI", attributes: cryptoSymbolAttributes)

                let combination = NSMutableAttributedString()

                combination.append(partOne)
                combination.append(partTwo)

                artLabel.attributedText = combination
            }

            if let liqPrice = cdp.liqPrice, let pip = cdp.pip {
                var riskColor = UIColor(hexString: "#6F6F6F")!
                // TODO: - For liquidated CDPs, replace numbers with liquidate status?
                var riskRange = "Unknown"
                if let ratio = cdp.ratio {
                    if ratio < 150.00 {
                        riskColor = UIColor(hexString: "#6F6F6F")!
                        riskRange = "Liquidated"
                    } else if ratio < 200.00 {
                        riskColor = UIColor(hexString: "#EA0201")!
                        riskRange = "Higher"
                    } else if ratio < 250.00 {
                        riskColor = UIColor(hexString: "#F6851B")!
                        riskRange = "Medium"
                    } else if ratio > 300.00 {
                        riskColor = UIColor(hexString: "#1ABC9C")!
                        riskRange = "Lower"
                    }
                }

                let cryptoAmountAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]
                let cryptoSymbolAttributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: riskColor,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
                ]

                let partOne = NSMutableAttributedString(string: "$\(String(format: "%.0f", pip)) · ", attributes: cryptoAmountAttributes)
                let partTwo = NSMutableAttributedString(string: "$\(String(format: "%.0f", liqPrice))", attributes: cryptoSymbolAttributes)

                let combination = NSMutableAttributedString()

                combination.append(partOne)
                combination.append(partTwo)

                liqPriceLabel.attributedText = combination
            }
        }
    }

    private let containerView: UIView = {
        let view = UIView()
//        let darkCardBackgroundColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        return view
    }()

    private let ethCircleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "eth"))
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return imageView
    }()

    private let identityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hexString: "#6F6F6F")
        return label
    }()

    private let liqPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(hexString: "#6F6F6F")
        label.clipsToBounds = true
        return label
    }()

    private let inkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(hexString: "#333333")
        label.clipsToBounds = true
        return label
    }()

    private let artLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(hexString: "#333333")
        label.clipsToBounds = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = UIColor(hexString: "#fbfbfb") // TODO: - what does this set?

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

        layer.zPosition = 104
    }

    required init?(coder _: NSCoder) {
        fatalError("unimplemented")
    }
}
