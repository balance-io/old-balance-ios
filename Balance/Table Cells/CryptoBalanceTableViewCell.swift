import SnapKit
import UIKit

class CryptoBalanceTableViewCell: ExpandableTableViewCell {
    enum CryptoType {
        case ethereum
        case erc20
    }

    let wallet: EthereumWallet
    let cryptoType: CryptoType

    override var isExpanded: Bool {
        willSet {
            if isExpanded != newValue {
                UIView.animate(withDuration: 0.2) {
                    self.setupLowValueTokensContainer(show: newValue)
                    self.flipExpandCollapseCaret(expanded: newValue)
                }
            }
        }
    }

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(hexString: "#EEEEEE")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let expandCaretView = UIImageView()

    private let titleIconView: UIImageView = {
        let titleIconView = UIImageView()
        return titleIconView
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor(hexString: "#272727")
        return titleLabel
    }()

    private let lowValueTokensContainer = UIView()

    init(withIdentifier reuseIdentifier: String, wallet: EthereumWallet, cryptoType: CryptoType, isExpanded: Bool, indexPath: IndexPath) {
        self.wallet = wallet
        self.cryptoType = cryptoType
        super.init(style: .default, reuseIdentifier: reuseIdentifier, isExpanded: isExpanded, indexPath: indexPath)

        isExpandable = (cryptoType == .erc20)

        selectionStyle = .none
        contentView.backgroundColor = UIColor(hexString: "#fbfbfb")

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }

        if isExpandable {
            expandCaretView.image = isExpanded ? UIImage(named: "collapse") : UIImage(named: "expand")
            contentView.addSubview(expandCaretView)
            expandCaretView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(containerView.snp.bottom).offset(-10)
            }
        }

        // TODO: remove title altogether
        containerView.addSubview(titleLabel)

        switch cryptoType {
        case .ethereum:

            let cryptoRow = CryptoRow(wallet: wallet)
            containerView.addSubview(cryptoRow)
            cryptoRow.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        case .erc20:

            if let tokens = wallet.tokens {
                let sortedTokens = tokens.sorted { left, right in
                    let leftFiatbalance = left.fiatBalance ?? 0
                    let rightFiatBalance = right.fiatBalance ?? 0
                    let leftSymbol = left.symbol ?? ""
                    let rightSymbol = right.symbol ?? ""

                    if leftFiatbalance > 0, rightFiatBalance > 0 {
                        return leftFiatbalance > rightFiatBalance
                    } else if leftFiatbalance > 0 {
                        return true
                    } else if rightFiatBalance > 0 {
                        return false
                    }

                    return leftSymbol < rightSymbol
                }

                var topView: UIView = titleLabel
                var isHighValueToken = true
                for token in sortedTokens {
                    let cryptoRow = CryptoRow(token: token)
                    if isHighValueToken, !cryptoRow.isHighValue {
                        isHighValueToken = false
                        setupLowValueTokensContainer(show: isExpanded)
                        addSubview(lowValueTokensContainer)
                        lowValueTokensContainer.snp.makeConstraints { make in
                            make.top.equalTo(topView.snp.bottom)
                            make.leading.equalToSuperview()
                            make.trailing.equalToSuperview()
                        }
                    }

                    let container = isHighValueToken ? containerView : lowValueTokensContainer
                    container.addSubview(cryptoRow)
                    cryptoRow.snp.makeConstraints { make in
                        let topOffset = topView == titleLabel ? 10 : 5
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

    required init?(coder _: NSCoder) {
        fatalError("unimplemented")
    }

    override func calculatedHeight() -> CGFloat {
        return CryptoBalanceTableViewCell.calculatedHeight(wallet: wallet, cryptoType: cryptoType, isExpanded: isExpanded)
    }

    private func setupLowValueTokensContainer(show: Bool) {
        lowValueTokensContainer.alpha = show ? 1.0 : 0.0
        lowValueTokensContainer.transform = show ? CGAffineTransform.identity : CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
    }

    private func flipExpandCollapseCaret(expanded: Bool) {
        expandCaretView.image = UIImage(named: expanded ? "collapse" : "expand")
    }

    static func calculatedHeight(wallet: EthereumWallet, cryptoType: CryptoType, isExpanded: Bool) -> CGFloat {
        var height: CGFloat = 0
        switch cryptoType {
        case .ethereum:
            height = 70
        case .erc20:
            let tokens = isExpanded ? wallet.tokens : wallet.valuableTokens
            let tokensCount = CGFloat(tokens?.count ?? 0)
            height = 25 + (tokensCount * 45)
        }
        return height
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

// https://stackoverflow.com/questions/18247934/how-to-align-uilabel-text-from-bottom
class VerticalAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        var newRect = rect
        switch contentMode {
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height
        case .bottom:
            let height = sizeThatFits(rect.size).height
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
        default:
            ()
        }

        super.drawText(in: newRect)
    }
}

private class CryptoRow: UIView {
    var isHighValue: Bool {
        return token?.fiatBalance ?? 0 >= Token.fiatValueCutoff
    }

    private var token: Token?

    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()

    private let tokenNameLabel: UILabel = {
        let tokenNameLabel = UILabel()
        tokenNameLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        tokenNameLabel.textColor = UIColor(hexString: "#6F6F6F")
        return tokenNameLabel
    }()

    private let cryptoBalanceLabel: VerticalAlignedLabel = {
        let cryptoBalanceLabel = VerticalAlignedLabel()
        cryptoBalanceLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        cryptoBalanceLabel.textColor = UIColor(hexString: "#272727")
        return cryptoBalanceLabel
    }()

    private let rateLabel: VerticalAlignedLabel = {
        let rateLabel = VerticalAlignedLabel()
        rateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        rateLabel.textColor = UIColor(hexString: "#6F6F6F")
        return rateLabel
    }()

    private let fiatBalanceLabel: UILabel = {
        let fiatBalanceLabel = UILabel()
        fiatBalanceLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        fiatBalanceLabel.textColor = UIColor(hexString: "#272727")
        fiatBalanceLabel.textAlignment = .right
        return fiatBalanceLabel
    }()

    convenience init(wallet: EthereumWallet) {
        // TODO: Move WETH into here
        self.init(balance: wallet.balance, fiatBalance: wallet.fiatBalance, rate: wallet.rate, symbol: wallet.symbol, currency: wallet.currency, name: "Ether")
    }

    convenience init(token: Token) {
        self.init(balance: token.balance, fiatBalance: token.fiatBalance, rate: token.rate, symbol: token.symbol, currency: token.currency, name: token.name)
        self.token = token
    }

    init(balance: Double?, fiatBalance: Double?, rate: Double?, symbol: String?, currency _: String?, name: String?) {
        super.init(frame: CGRect.zero)

        // TODO: - Add a random color + token symbol instead of just the ERC20 token image
        if let symbol = symbol, !symbol.isEmpty {
            iconImageView.image = UIImage(named: symbol.lowercased()) ?? UIImage(named: "erc20")
        } else {
            iconImageView.image = UIImage(named: "erc20")
        }
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }

        var tokenRate = ""
        if let rate = rate {
            if rate == 0 {
                fiatNumberFormatter.minimumFractionDigits = 0
                fiatNumberFormatter.maximumFractionDigits = 0
            } else {
                fiatNumberFormatter.minimumFractionDigits = 2
                fiatNumberFormatter.maximumFractionDigits = 2
            }
            if let rateString = fiatNumberFormatter.string(from: rate as NSNumber) {
                tokenRate = "\(rateString)"
            }
        }
        rateLabel.text = tokenRate
        rateLabel.textAlignment = .right
        addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.height.equalTo(iconImageView).multipliedBy(0.5)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(iconImageView).offset(-2)
        }

        tokenNameLabel.text = name
        addSubview(tokenNameLabel)
        tokenNameLabel.snp.makeConstraints { make in
            make.height.equalTo(rateLabel)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalTo(rateLabel.snp.leading).offset(-10)
            make.top.equalTo(rateLabel)
        }

        var cryptoBalance = "0"
        if let balance = balance {
            // TODO: - Fix this for multi-currency
            if let rate = rate {
                if rate > 1000 {
                    cryptoNumberFormatter.maximumFractionDigits = 4
                    cryptoNumberFormatter.minimumFractionDigits = 4
                } else if rate > 100 {
                    cryptoNumberFormatter.maximumFractionDigits = 2
                    cryptoNumberFormatter.minimumFractionDigits = 2
                } else {
                    cryptoNumberFormatter.maximumFractionDigits = 2
                    cryptoNumberFormatter.minimumFractionDigits = 2
                }
                cryptoBalance = cryptoNumberFormatter.string(from: balance as NSNumber) ?? "0"
            }
        }

//        let collateral = ink
//        let collateralFormatted = numberFormatter.string(from: NSNumber(value: collateral))

        let combination = NSMutableAttributedString()

        let cryptoAmountAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        let cryptoSymbolAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]

        let partOne = NSMutableAttributedString(string: "\(String(cryptoBalance))", attributes: cryptoAmountAttributes)
        combination.append(partOne)

        if let symbol = symbol {
            let partTwo = NSMutableAttributedString(string: " \(symbol)", attributes: cryptoSymbolAttributes)
            combination.append(partTwo)
        }

//        inkLabel.attributedText = combination

//        cryptoBalanceLabel.text = cryptoBalance
        cryptoBalanceLabel.attributedText = combination

        addSubview(cryptoBalanceLabel)
        cryptoBalanceLabel.snp.makeConstraints { make in
            make.height.equalTo(iconImageView).multipliedBy(0.5)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.bottom.equalTo(iconImageView).offset(2)
        }

        fiatBalanceLabel.textAlignment = .right
        fiatBalanceLabel.contentMode = .top
        fiatBalanceLabel.text = ""
        if let fiatBalance = fiatBalance {
            if fiatBalance > 100 {
                fiatNumberFormatter.minimumFractionDigits = 0
                fiatNumberFormatter.maximumFractionDigits = 0
            } else if fiatBalance < 100 {
                fiatNumberFormatter.minimumFractionDigits = 0
                fiatNumberFormatter.maximumFractionDigits = 0
            } else if fiatBalance < 1 {
                fiatNumberFormatter.minimumFractionDigits = 2
                fiatNumberFormatter.maximumFractionDigits = 2
            }

            fiatBalanceLabel.text = fiatNumberFormatter.string(from: fiatBalance as NSNumber) ?? "—"
        }
        addSubview(fiatBalanceLabel)

        fiatBalanceLabel.snp.makeConstraints { make in
            make.height.equalTo(cryptoBalanceLabel)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(iconImageView).offset(2)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("unimplemented")
    }
}
