//
//  CDPTableViewCell.swift
//  Balance
//
//  Created by Richard Burton on 21/02/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit
import SnapKit

class CDPTableViewCell: UITableViewCell {
    var cdp: CDP? {
        didSet {
            guard let cdpItem = cdp else {return}
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.maximumFractionDigits = 0
            
            if let identifier = cdpItem.identifier {
                identityLabel.text = "Maker CDP #\(identifier)"
            }
            
            if let ratio = cdpItem.ratio {
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
            
            if let ink = cdpItem.ink, let pip = cdpItem.pip {
                let collateral = ink * pip
                let collateralFormatted = numberFormatter.string(from: NSNumber(value:collateral))
                inkLabel.text = "\(String(collateralFormatted!)) USD"
            }

            if let art = cdpItem.art {
                let artFormatted = numberFormatter.string(from: NSNumber(value:art))
                artLabel.text = "\(artFormatted!) DAI"
            }
            
            if let liqPrice = cdpItem.liqPrice, let pip = cdpItem.pip {
                liqPriceLabel.text = "$\(String(format:"%.0f", pip)) / \(String(format:"%.0f", liqPrice))"
            }
        }
    }
    
    private let identityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ethCircleImageView: UIImageView = {
        let image = UIImage(named: "ethWhiteCircle")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mkrSquircle: UIImageView = {
        let image = UIImage(named: "mkrSquircle")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let daiCircle: UIImageView = {
        let image = UIImage(named: "daiCircle")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let checkCircle: UIImageView = {
        let image = UIImage(named: "checkCircle")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let collateralizedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Collateral"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let debtTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Debt"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let positionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Position"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.padding = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 4)
        label.textColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let liqPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        let darkCardBackgroundColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        view.backgroundColor = darkCardBackgroundColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView?.backgroundColor = selected ? .red : nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
}
