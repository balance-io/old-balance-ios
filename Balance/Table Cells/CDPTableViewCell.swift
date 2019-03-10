//
//  CDPTableViewCell.swift
//  Balance
//
//  Created by Richard Burton on 21/02/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

class CDPTableViewCell: UITableViewCell {
    
    var cdp:CDP? {
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

            if let art = cdpItem.art {
                let artFormatted = numberFormatter.string(from: NSNumber(value:art))
                artLabel.text = "\(artFormatted!) DAI"
            }
            
            if let ink = cdpItem.ink {
                if let pip = cdpItem.pip {
                    let collateral = ink * pip
                    let collateralFormatted = numberFormatter.string(from: NSNumber(value:collateral))
                    inkLabel.text = "\(String(collateralFormatted!)) USD"
                }
            }
            
            if let liqPrice = cdpItem.liqPrice {
                if let pip = cdpItem.pip {
                    liqPriceLabel.text = "$\(String(format:"%.0f", pip)) / \(String(format:"%.0f", liqPrice))"
                }
            }
        }
    }
    
    let identityLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ethCircleImageView:UIImageView = {
        let image = UIImage(named: "ethWhiteCircle")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let mkrSquircle:UIImageView = {
        let image = UIImage(named: "mkrSquircle")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let daiCircle:UIImageView = {
        let image = UIImage(named: "daiCircle")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let checkCircle:UIImageView = {
        let image = UIImage(named: "checkCircle")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let collateralizedTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Collateral"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let debtTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Debt"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let positionTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Position"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratioLabel:UILabel = {
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
    
    let pipLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let inkLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let liqPriceLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        
        let darkCardBackgroundColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        view.backgroundColor = darkCardBackgroundColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let lineView:UIView = {
        let line = UIView(frame: CGRect())
        line.backgroundColor = .white
        line.alpha = 0.8
        line.layer.cornerRadius = 5
        
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)

        containerView.addSubview(lineView)
        containerView.addSubview(identityLabel)
        containerView.addSubview(ethCircleImageView)
        containerView.addSubview(mkrSquircle)
        containerView.addSubview(daiCircle)
        containerView.addSubview(checkCircle)
        containerView.addSubview(collateralizedTitleLabel)
        containerView.addSubview(debtTitleLabel)
        containerView.addSubview(positionTitleLabel)
        containerView.addSubview(ratioLabel)
        containerView.addSubview(pipLabel)
        containerView.addSubview(artLabel)
        containerView.addSubview(inkLabel)
        containerView.addSubview(liqPriceLabel)
        
        self.contentView.addSubview(containerView)
        
        containerView.heightAnchor.constraint(equalToConstant: 300)
        containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true

        mkrSquircle.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 20).isActive = true
        mkrSquircle.leadingAnchor.constraint(equalTo:containerView.leadingAnchor, constant: 15).isActive = true
        
        ethCircleImageView.topAnchor.constraint(equalTo:mkrSquircle.bottomAnchor, constant: 12).isActive = true
        ethCircleImageView.centerXAnchor.constraint(equalTo:mkrSquircle.centerXAnchor, constant: 0).isActive = true
        
        daiCircle.topAnchor.constraint(equalTo:ethCircleImageView.bottomAnchor, constant: 12).isActive = true
        daiCircle.centerXAnchor.constraint(equalTo:ethCircleImageView.centerXAnchor, constant: 0).isActive = true
        
        checkCircle.topAnchor.constraint(equalTo:daiCircle.bottomAnchor, constant: 12).isActive = true
        checkCircle.centerXAnchor.constraint(equalTo:ethCircleImageView.centerXAnchor, constant: 0).isActive = true
        
        identityLabel.centerYAnchor.constraint(equalTo:mkrSquircle.centerYAnchor, constant: 0).isActive = true
        identityLabel.leadingAnchor.constraint(equalTo:mkrSquircle.trailingAnchor, constant: 5).isActive = true
        identityLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8).isActive = true
        
        collateralizedTitleLabel.centerYAnchor.constraint(equalTo:self.ethCircleImageView.centerYAnchor, constant: 0).isActive = true
        collateralizedTitleLabel.leadingAnchor.constraint(equalTo:self.ethCircleImageView.trailingAnchor, constant: 5).isActive = true

        debtTitleLabel.topAnchor.constraint(equalTo: daiCircle.topAnchor, constant: 0).isActive = true
        debtTitleLabel.leadingAnchor.constraint(equalTo: collateralizedTitleLabel.leadingAnchor, constant: 0).isActive = true

        positionTitleLabel.topAnchor.constraint(equalTo: checkCircle.topAnchor, constant: 0).isActive = true
        positionTitleLabel.leadingAnchor.constraint(equalTo: debtTitleLabel.leadingAnchor, constant: 0).isActive = true
        
        ratioLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        ratioLabel.centerYAnchor.constraint(equalTo: identityLabel.centerYAnchor).isActive = true
        ratioLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.17).isActive = true
        
        inkLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        inkLabel.centerYAnchor.constraint(equalTo: collateralizedTitleLabel.centerYAnchor, constant: 0).isActive = true
        inkLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.55).isActive = true
        
        artLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        artLabel.centerYAnchor.constraint(equalTo: debtTitleLabel.centerYAnchor, constant: 0).isActive = true
        artLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.55).isActive = true
        
        liqPriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        liqPriceLabel.centerYAnchor.constraint(equalTo: positionTitleLabel.centerYAnchor, constant: 0).isActive = true
        liqPriceLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.55).isActive = true
        
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView!.backgroundColor = selected ? .red : nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
