//
//  CryptoBalanceTableViewCell.swift
//  Balance
//
//  Created by Benjamin Baron on 3/12/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit
import SnapKit

class CryptoBalanceTableViewCell: UITableViewCell {
    enum CryptoType {
        case ethereum
        case erc20
    }
    
    let cryptoType: CryptoType
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(hexString: "#EEEEEE")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let titleIconView: UIImageView = {
        let titleIconView = UIImageView()
        titleIconView.translatesAutoresizingMaskIntoConstraints = false
        return titleIconView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor(hexString: "#333333")
        return titleLabel
    }()
    
    init(wallet: EthereumWallet, cryptoType: CryptoType) {
        self.cryptoType = cryptoType
        super.init(style: .default, reuseIdentifier: "cryptoCell")
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor(hexString: "#fbfbfb")
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.addSubview(titleIconView)
        titleIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(14)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleIconView.snp.trailing).offset(10)
            make.centerY.equalTo(titleIconView)
        }
        
        switch cryptoType {
        case .ethereum:
            titleIconView.image = UIImage(named: "ethSquircleDark")
            titleLabel.text = "Ethereum"
            
            let cryptoRow = CryptoRow(wallet: wallet)
            addSubview(cryptoRow)
            cryptoRow.snp.makeConstraints { make in
                make.top.equalTo(titleIconView.snp.bottom).offset(20)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(40)
            }
        case .erc20:
            titleIconView.image = UIImage(named: "erc20SquircleGreen")
            titleLabel.text = "ERC-20 Tokens"
            
            if let tokens = wallet.tokens {
                let sortedTokens = tokens.sorted { left, right in
                    let leftFiatbalance = left.fiatBalance ?? 0
                    let rightFiatBalance = right.fiatBalance ?? 0
                    let leftSymbol = left.symbol ?? ""
                    let rightSymbol = right.symbol ?? ""
                    
                    if leftFiatbalance > 0 && rightFiatBalance > 0 {
                        return leftFiatbalance > rightFiatBalance
                    } else if leftFiatbalance > 0 {
                        return true
                    } else if rightFiatBalance > 0 {
                        return false
                    }
                    
                    return leftSymbol < rightSymbol
                }
                
                var topView: UIView = titleIconView
                for token in sortedTokens {
                    let cryptoRow = CryptoRow(token: token)
                    addSubview(cryptoRow)
                    cryptoRow.snp.makeConstraints { make in
                        let topOffset = topView == titleIconView ? 20 : 5
                        make.top.equalTo(topView.snp.bottom).offset(topOffset)
                        make.leading.equalToSuperview()
                        make.trailing.equalToSuperview()
                        make.height.equalTo(40)
                    }
                    topView = cryptoRow
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
    
    static func calculatedHeight(wallet: EthereumWallet, cryptoType: CryptoType) -> CGFloat {
        switch cryptoType {
        case .ethereum:
            return CGFloat(30 + 14 + 25 + 10 + 50)
        case .erc20:
            let tokensCount = wallet.tokens?.count ?? 0
            return CGFloat(30 + 14 + 25 + 10 + (tokensCount * 45) + 5)
        }
    }
}

private let wholeNumberFormatter: NumberFormatter = {
    let wholeNumberFormatter = NumberFormatter()
    wholeNumberFormatter.minimumFractionDigits = 0
    wholeNumberFormatter.maximumFractionDigits = 0
    return wholeNumberFormatter
}()

private let cryptoNumberFormatter: NumberFormatter = {
    let cryptoNumberFormatter = NumberFormatter()
    cryptoNumberFormatter.minimumFractionDigits = 0
    cryptoNumberFormatter.maximumFractionDigits = 4
    cryptoNumberFormatter.numberStyle = .decimal
    return cryptoNumberFormatter
}()

private let fiatNumberFormatter: NumberFormatter = {
    let fiatNumberFormatter = NumberFormatter()
    fiatNumberFormatter.minimumFractionDigits = 2
    fiatNumberFormatter.maximumFractionDigits = 2
    fiatNumberFormatter.currencyCode = "USD"
    fiatNumberFormatter.currencySymbol = "$"
    fiatNumberFormatter.locale = Locale(identifier: "en_US")
    fiatNumberFormatter.numberStyle = .currency
    return fiatNumberFormatter
}()

private class CryptoRow: UIView {
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    
    let cryptoBalanceLabel: UILabel = {
        let cryptoBalanceLabel = UILabel()
        cryptoBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        cryptoBalanceLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        cryptoBalanceLabel.textColor = UIColor(hexString: "#333333")
        return cryptoBalanceLabel
    }()
    
    let rateLabel: UILabel = {
        let rateLabel = UILabel()
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        rateLabel.textColor = UIColor(hexString: "#333333")
        return rateLabel
    }()
    
    let fiatBalanceLabel: UILabel = {
        let fiatBalanceLabel = UILabel()
        fiatBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        fiatBalanceLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 25, weight: .regular)
        fiatBalanceLabel.textColor = UIColor(hexString: "#333333")
        fiatBalanceLabel.textAlignment = .right
        return fiatBalanceLabel
    }()
    
    convenience init(wallet: EthereumWallet) {
        self.init(balance: wallet.balance, fiatBalance: wallet.fiatBalance, rate: wallet.rate, symbol: wallet.symbol, currency: wallet.currency)
    }
    
    convenience init(token: Token) {
        self.init(balance: token.balance, fiatBalance: token.fiatBalance, rate: token.rate, symbol: token.symbol, currency: token.currency)
    }
    
    init(balance: Double?, fiatBalance: Double?, rate: Double?, symbol: String?, currency: String?) {
        super.init(frame: CGRect.zero)
        
        if let symbol = symbol {
            iconImageView.image = UIImage(named: symbol.lowercased()) ?? UIImage(named: "erc20SquircleGreen")
        }
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        fiatBalanceLabel.text = "$0"
        if let fiatBalance = fiatBalance {
            fiatBalanceLabel.text = fiatNumberFormatter.string(from: fiatBalance as NSNumber) ?? "$0"
        }
        addSubview(fiatBalanceLabel)
        fiatBalanceLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-17)
        }
        
        var cryptoBalance = "0"
        if let balance = balance {
            cryptoBalance = wholeNumberFormatter.string(from: balance as NSNumber) ?? "0"
        }
        if let symbol = symbol {
            cryptoBalance += " \(symbol.uppercased())"
        }
        cryptoBalanceLabel.text = cryptoBalance
        addSubview(cryptoBalanceLabel)
        cryptoBalanceLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.5)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalTo(fiatBalanceLabel.snp.leading).offset(-10)
            make.top.equalToSuperview()
        }
        
        var tokenRate = "×"
        if let rate = rate, let rateString = cryptoNumberFormatter.string(from: rate as NSNumber) {
            tokenRate += " \(rateString)"
        } else {
            tokenRate += " 0"
        }
        if let currency = currency {
            tokenRate += " \(currency.uppercased())"
        } else {
            tokenRate += " USD"
        }
        rateLabel.text = tokenRate
        addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.height.equalTo(cryptoBalanceLabel)
            make.leading.equalTo(cryptoBalanceLabel)
            make.trailing.equalTo(cryptoBalanceLabel)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
}
