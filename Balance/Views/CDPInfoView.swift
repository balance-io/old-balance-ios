//
//  CDPInfoView.swift
//  Balance
//
//  Created by Benjamin Baron on 3/10/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

private let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter
}()

class CDPInfoView: UIView {
    let mkrGreenImageView: UIImageView = {
        let mkrGreenImageView = UIImageView(image: UIImage(named: "mkrGreen"))
        mkrGreenImageView.frame = CGRect(x:0, y: 0, width: 32, height: 32)
        mkrGreenImageView.translatesAutoresizingMaskIntoConstraints = false
        return mkrGreenImageView
    }()
    
    let identifierLabel: UILabel = {
        let identifierLabel = UILabel()
        identifierLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        identifierLabel.textColor = .white
        identifierLabel.translatesAutoresizingMaskIntoConstraints = false
        return identifierLabel
    }()
    
    let collateralTitleLabel: UILabel = {
        let collateralTitleLabel = UILabel()
        collateralTitleLabel.text = "COLLATERAL"
        collateralTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        collateralTitleLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        collateralTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return collateralTitleLabel
    }()
    
    let ethCircleImageView: UIImageView = {
        let ethCircleImage = UIImage(named: "ethWhiteCircle")
        let ethCircleImageView = UIImageView(image: ethCircleImage)
        ethCircleImageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        ethCircleImageView.translatesAutoresizingMaskIntoConstraints = false
        return ethCircleImageView
    }()
    
    let etherTitleLabel: UILabel = {
        let etherTitleLabel = UILabel()
        etherTitleLabel.text = "Ether"
        etherTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        etherTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        etherTitleLabel.textColor = .white
        return etherTitleLabel
    }()
    
    let collateralBreakdownLabel: UILabel = {
        let collateralBreakdownLabel = UILabel()
        collateralBreakdownLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        collateralBreakdownLabel.translatesAutoresizingMaskIntoConstraints = false
        collateralBreakdownLabel.textColor = .white
        return collateralBreakdownLabel
    }()
    
    let debtTitleLabel: UILabel = {
        let debtTitleLabel = UILabel()
        debtTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        debtTitleLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        debtTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        debtTitleLabel.text = "DEBT"
        return debtTitleLabel
    }()
    
    let daiCircleImageView: UIImageView = {
        let daiCircleImage = UIImage(named: "daiCircle")
        let daiCircleImageView = UIImageView(image: daiCircleImage)
        daiCircleImageView.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        daiCircleImageView.translatesAutoresizingMaskIntoConstraints = false
        return daiCircleImageView
    }()
    
    let daiTitleLabel: UILabel = {
        let daiTitleLabel = UILabel()
        daiTitleLabel.text = "Dai"
        daiTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        daiTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        daiTitleLabel.textColor = .white
        return daiTitleLabel
    }()
    
    let debtBreakdownLabel: UILabel = {
        let debtBreakdownLabel = UILabel()
        debtBreakdownLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        debtBreakdownLabel.translatesAutoresizingMaskIntoConstraints = false
        debtBreakdownLabel.textColor = .white
        return debtBreakdownLabel
    }()
    
    let positionTitleLabel: UILabel = {
        let positionTitleLabel = UILabel()
        positionTitleLabel.text = "POSITION"
        positionTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        positionTitleLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        positionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return positionTitleLabel
    }()
    
    let riskTitleLabel: UILabel = {
        let riskTitleLabel = UILabel()
        riskTitleLabel.text = "RISK"
        riskTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        riskTitleLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        riskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return riskTitleLabel
    }()
    
    let priceTitleLabel: UILabel = {
        let priceTitleLabel = UILabel()
        priceTitleLabel.text = "PRICE"
        priceTitleLabel.textAlignment = .center
        priceTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        priceTitleLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceTitleLabel
    }()
    
    let ratioTitleLabel: UILabel = {
        let ratioTitleLabel = UILabel()
        ratioTitleLabel.text = "RATIO"
        ratioTitleLabel.textAlignment = .right
        ratioTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        ratioTitleLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        ratioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return ratioTitleLabel
    }()
    
    let riskLabel: UILabel = {
        let riskLabel = UILabel()
        riskLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        riskLabel.padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        riskLabel.textColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        riskLabel.layer.cornerRadius = 5
        riskLabel.clipsToBounds = true
        riskLabel.translatesAutoresizingMaskIntoConstraints = false
        return riskLabel
    }()
    
    let liqPriceLabel: UILabel = {
        let liqPriceLabel = UILabel()
        liqPriceLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        liqPriceLabel.padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        liqPriceLabel.textColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        liqPriceLabel.layer.cornerRadius = 5
        liqPriceLabel.clipsToBounds = true
        liqPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        return liqPriceLabel
    }()
    
    let ratioLabel: UILabel = {
        let ratioLabel = UILabel()
        ratioLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        ratioLabel.padding = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 4)
        ratioLabel.textColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        ratioLabel.layer.cornerRadius = 5
        ratioLabel.clipsToBounds = true
        ratioLabel.translatesAutoresizingMaskIntoConstraints = false
        return ratioLabel
    }()
    
    let riskBarImageView: UIImageView = {
        let riskBarImage = UIImage(named: "riskbar")
        let riskBarImageView = UIImageView(image: riskBarImage)
        riskBarImageView.frame = CGRect(x:0, y: 0, width: 345, height: 23)
        riskBarImageView.translatesAutoresizingMaskIntoConstraints = false
        return riskBarImageView
    }()
    
    let riskDotImageView: UIImageView = {
        let riskDotImage = UIImage(named: "riskDot")
        let riskDotImageView = UIImageView(image: riskDotImage)
        riskDotImageView.frame = CGRect(x:0, y: 0, width: 345, height: 23)
        riskDotImageView.translatesAutoresizingMaskIntoConstraints = false
        return riskDotImageView
    }()
    
    let rektLabel: UILabel = {
        let rektLabel = UILabel()
        rektLabel.text = "150%"
        rektLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        rektLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        rektLabel.translatesAutoresizingMaskIntoConstraints = false
        return rektLabel
    }()
    
    let dangerLabel: UILabel = {
        let dangerLabel = UILabel()
        dangerLabel.text = "250%"
        dangerLabel.textAlignment = .center
        dangerLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        dangerLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        dangerLabel.translatesAutoresizingMaskIntoConstraints = false
        return dangerLabel
    }()
    
    let saferLabel: UILabel = {
        let saferLabel = UILabel()
        saferLabel.text = "350%"
        saferLabel.textAlignment = .right
        saferLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        saferLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        saferLabel.translatesAutoresizingMaskIntoConstraints = false
        return saferLabel
    }()
    
    let plainEnglishContainerView: UIView = {
        let plainEnglishContainerView = UIView()
        // TODO Find a way to get the UILabel to stretch dynamically.
        plainEnglishContainerView.translatesAutoresizingMaskIntoConstraints = false
        return plainEnglishContainerView
    }()
    
    let plainEnglishExplanationLabel: UILabel = {
        let plainEnglishExplanationLabel = UILabel()
        plainEnglishExplanationLabel.translatesAutoresizingMaskIntoConstraints = false
        plainEnglishExplanationLabel.textAlignment = .center
        plainEnglishExplanationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        plainEnglishExplanationLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.5)
        plainEnglishExplanationLabel.lineBreakMode = .byWordWrapping
        plainEnglishExplanationLabel.numberOfLines = 0
        return plainEnglishExplanationLabel
    }()
    
    init(cdpItem: CDP) {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor(red:0.11, green:0.13, blue:0.16, alpha:1.0)
        clipsToBounds = true
        layer.cornerRadius = 20
        
        addSubview(mkrGreenImageView)
        mkrGreenImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        mkrGreenImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        identifierLabel.text = "Maker CDP #\(cdpItem.identifier!.description)"
        addSubview(identifierLabel)
        identifierLabel.leadingAnchor.constraint(equalTo: mkrGreenImageView.trailingAnchor, constant: 10).isActive = true
        identifierLabel.centerYAnchor.constraint(equalTo: mkrGreenImageView.centerYAnchor).isActive = true
        
        addSubview(collateralTitleLabel)
        collateralTitleLabel.leadingAnchor.constraint(equalTo: mkrGreenImageView.leadingAnchor).isActive = true
        collateralTitleLabel.topAnchor.constraint(equalTo: mkrGreenImageView.bottomAnchor, constant: 15).isActive = true
        
        addSubview(ethCircleImageView)
        ethCircleImageView.topAnchor.constraint(equalTo:collateralTitleLabel.bottomAnchor, constant: 10).isActive = true
        ethCircleImageView.leadingAnchor.constraint(equalTo:mkrGreenImageView.leadingAnchor, constant: 0).isActive = true
        
        addSubview(etherTitleLabel)
        etherTitleLabel.leadingAnchor.constraint(equalTo: ethCircleImageView.trailingAnchor, constant: 10).isActive = true
        etherTitleLabel.centerYAnchor.constraint(equalTo: ethCircleImageView.centerYAnchor).isActive = true
        
        if let ink = cdpItem.ink {
            if let pip = cdpItem.pip {
                let inkString = numberFormatter.string(from: NSNumber(value: ink))
                let pipString = numberFormatter.string(from: NSNumber(value: pip))
                if let inkString = inkString, let pipString = pipString {
                    collateralBreakdownLabel.text = "\(inkString) ETH * \(pipString) USD"
                } else {
                    print("Failed to format inkString: \(String(describing: inkString)) or pipString: \(String(describing: pipString))")
                }
            }
        }
        addSubview(collateralBreakdownLabel)
        collateralBreakdownLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        collateralBreakdownLabel.topAnchor.constraint(equalTo: collateralTitleLabel.bottomAnchor, constant: 10).isActive = true
        
        addSubview(debtTitleLabel)
        debtTitleLabel.leadingAnchor.constraint(equalTo: mkrGreenImageView.leadingAnchor).isActive = true
        debtTitleLabel.topAnchor.constraint(equalTo: ethCircleImageView.bottomAnchor, constant: 15).isActive = true
        
        addSubview(daiCircleImageView)
        daiCircleImageView.topAnchor.constraint(equalTo:debtTitleLabel.bottomAnchor, constant: 10).isActive = true
        daiCircleImageView.leadingAnchor.constraint(equalTo:mkrGreenImageView.leadingAnchor, constant: 0).isActive = true
        
        addSubview(daiTitleLabel)
        daiTitleLabel.leadingAnchor.constraint(equalTo: daiCircleImageView.trailingAnchor, constant: 10).isActive = true
        daiTitleLabel.centerYAnchor.constraint(equalTo: daiCircleImageView.centerYAnchor).isActive = true
        
        if let art = cdpItem.art {
            let artString = numberFormatter.string(from: NSNumber(value:art))
            if let artString = artString {
                debtBreakdownLabel.text = "\(artString) DAI * 1.00 USD"
            } else {
                print("Failed to format artString: \(String(describing: artString))")
            }
        }
        addSubview(debtBreakdownLabel)
        debtBreakdownLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        debtBreakdownLabel.centerYAnchor.constraint(equalTo: daiCircleImageView.centerYAnchor).isActive = true
        
        addSubview(positionTitleLabel)
        positionTitleLabel.leadingAnchor.constraint(equalTo: mkrGreenImageView.leadingAnchor).isActive = true
        positionTitleLabel.topAnchor.constraint(equalTo: debtBreakdownLabel.bottomAnchor, constant: 15).isActive = true
    
        addSubview(riskTitleLabel)
        riskTitleLabel.leadingAnchor.constraint(equalTo: mkrGreenImageView.leadingAnchor).isActive = true
        riskTitleLabel.topAnchor.constraint(equalTo: positionTitleLabel.bottomAnchor, constant: 10).isActive = true
        
        addSubview(priceTitleLabel)
        priceTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        priceTitleLabel.centerYAnchor.constraint(equalTo: riskTitleLabel.centerYAnchor).isActive = true
        
        addSubview(ratioTitleLabel)
        ratioTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        ratioTitleLabel.centerYAnchor.constraint(equalTo: riskTitleLabel.centerYAnchor).isActive = true
        
        var riskColor = UIColor.white
        var riskRange = "Unknown"
        if let ratio = cdpItem.ratio {
            if ratio < 150.00 {
                riskColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.5)
                riskRange = "Liquidated"
            } else if ratio < 200.00 {
                riskColor = .red
                riskRange = "Higher"
            } else if ratio < 250.00 {
                riskColor = .orange
                riskRange = "Medium"
            } else if ratio > 300.00 {
                riskColor = .green
                riskRange = "Lower"
            }
        }
        riskLabel.text = riskRange
        riskLabel.backgroundColor = riskColor
        addSubview(riskLabel)
        riskLabel.leadingAnchor.constraint(equalTo: riskTitleLabel.leadingAnchor).isActive = true
        riskLabel.topAnchor.constraint(equalTo: riskTitleLabel.bottomAnchor, constant: 5).isActive = true
        
        if let liqPrice = cdpItem.liqPrice, let pip = cdpItem.pip {
            liqPriceLabel.text = "$\(String(format:"%.0f", pip)) / \(String(format:"%.0f", liqPrice))"
        }
        liqPriceLabel.backgroundColor = riskColor
        addSubview(liqPriceLabel)
        liqPriceLabel.centerXAnchor.constraint(equalTo: priceTitleLabel.centerXAnchor, constant: 0).isActive = true
        liqPriceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 5).isActive = true
        
        if let ratio = cdpItem.ratio {
            ratioLabel.text = " \(String(format:"%.0f", ratio))%"
        }
        ratioLabel.backgroundColor = riskColor
        addSubview(ratioLabel)
        ratioLabel.trailingAnchor.constraint(equalTo: ratioTitleLabel.trailingAnchor, constant: 0).isActive = true
        ratioLabel.topAnchor.constraint(equalTo: ratioTitleLabel.bottomAnchor, constant: 5).isActive = true
        
        addSubview(riskBarImageView)
        riskBarImageView.topAnchor.constraint(equalTo: riskLabel.bottomAnchor, constant: 20).isActive = true
        riskBarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        riskBarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
        addSubview(riskDotImageView)
        riskDotImageView.centerYAnchor.constraint(equalTo: riskBarImageView.centerYAnchor, constant: 0).isActive = true
        
        let width = riskBarImageView.frame.size.width
        print(width)
        let widthPercent:Double = Double(width / 100.00)
        print(widthPercent)
        
        if let ratio = cdpItem.ratio {
            if ratio <= 150.00 {
                riskDotImageView.leadingAnchor.constraint(equalTo: riskBarImageView.leadingAnchor, constant: 0).isActive = true
            } else if ratio >= 320.00 {
                riskDotImageView.trailingAnchor.constraint(equalTo: riskBarImageView.trailingAnchor, constant: 0).isActive = true
            } else {
                let pointsAway = ratio - 150.00
                let riskDotPositionFromLeft = (pointsAway / 2) * widthPercent
                riskDotImageView.leadingAnchor.constraint(equalTo: riskBarImageView.leadingAnchor, constant: CGFloat(riskDotPositionFromLeft)).isActive = true
            }
        }
        
        addSubview(rektLabel)
        rektLabel.leadingAnchor.constraint(equalTo: mkrGreenImageView.leadingAnchor).isActive = true
        rektLabel.topAnchor.constraint(equalTo: riskBarImageView.bottomAnchor, constant: 10).isActive = true
        
        addSubview(dangerLabel)
        dangerLabel.centerXAnchor.constraint(equalTo: riskBarImageView.centerXAnchor).isActive = true
        dangerLabel.centerYAnchor.constraint(equalTo: rektLabel.centerYAnchor).isActive = true
        
        addSubview(saferLabel)
        saferLabel.trailingAnchor.constraint(equalTo: riskBarImageView.trailingAnchor).isActive = true
        saferLabel.centerYAnchor.constraint(equalTo: rektLabel.centerYAnchor).isActive = true
        
        addSubview(plainEnglishContainerView)
        plainEnglishContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        plainEnglishContainerView.leadingAnchor.constraint(equalTo: mkrGreenImageView.leadingAnchor).isActive = true
        plainEnglishContainerView.trailingAnchor.constraint(equalTo: saferLabel.trailingAnchor).isActive = true
        plainEnglishContainerView.topAnchor.constraint(equalTo: rektLabel.bottomAnchor, constant: 15).isActive = true
        plainEnglishContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        
        var textForPlainEnglishExplanationLabel = ""
        if let liqPrice = cdpItem.liqPrice {
            textForPlainEnglishExplanationLabel = "If Ether drops to $\(String(format:"%.0f", liqPrice)) your CDP will hit the ratio of 150% and be liquidated."
        }
        plainEnglishExplanationLabel.text = textForPlainEnglishExplanationLabel
        plainEnglishExplanationLabel.sizeToFit()
        addSubview(plainEnglishExplanationLabel)
        plainEnglishExplanationLabel.leadingAnchor.constraint(equalTo: mkrGreenImageView.leadingAnchor).isActive = true
        plainEnglishExplanationLabel.trailingAnchor.constraint(equalTo: saferLabel.trailingAnchor).isActive = true
        plainEnglishExplanationLabel.topAnchor.constraint(equalTo: rektLabel.bottomAnchor, constant: 15).isActive = true
        plainEnglishExplanationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
}
