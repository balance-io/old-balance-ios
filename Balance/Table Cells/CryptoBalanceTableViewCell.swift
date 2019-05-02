import SnapKit
import UIKit

class CryptoBalanceTableViewCell: ExpandableTableViewCell {
    enum CryptoType {
        case ethereum
        case erc20
    }

    let wallet: EthereumWallet
    let cryptoType: CryptoType

    private var expandCollapseRow: ExpandCollapseRow?

    override var isExpanded: Bool {
        willSet {
            if isExpanded != newValue {
                UIView.animate(withDuration: 0.2) {
                    self.toggleVisibilityOfLowValueTokensContainer(show: newValue)
                    self.expandCollapseRow?.isExpanded = newValue
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
    private let highValueTokensContainer = UIView()

    init(withIdentifier reuseIdentifier: String, wallet: EthereumWallet, cryptoType: CryptoType, isExpanded: Bool, indexPath: IndexPath) {
        self.wallet = wallet
        self.cryptoType = cryptoType

        super.init(style: .default, reuseIdentifier: reuseIdentifier, isExpanded: isExpanded, indexPath: indexPath)

        isExpandable = (cryptoType == .erc20) && !wallet.isAlwaysExpanded()

        selectionStyle = .none
        contentView.backgroundColor = UIColor(hexString: "#fbfbfb")

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
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

                let cryptoRows = sortedTokens.map { CryptoRow(token: $0) }
                let highValueMap = Dictionary(grouping: cryptoRows, by: { $0.isHighValue })
                var topView: UIView = titleLabel

                // Wrap the high value tokens
                containerView.addSubview(highValueTokensContainer)
                highValueTokensContainer.snp.makeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.trailing.equalToSuperview()
                    make.leading.equalToSuperview()
                }

                // High value tokens go first
                for tokenRow in highValueMap[true] ?? [] {
                    highValueTokensContainer.addSubview(tokenRow)
                    tokenRow.snp.makeConstraints { make in
                        make.top.equalTo(topView.snp.bottom).offset(10)
                        make.leading.equalToSuperview()
                        make.trailing.equalToSuperview()
                        make.height.equalTo(CryptoRow.rowHeight)
                    }
                    topView = tokenRow
                }

                // Do we have any lower-value tokens? If so, then append the expander row
                // and render them all into the low value tokens container.
                if highValueMap[false] != nil {
                    // Initialise the low value tokens container
                    containerView.addSubview(lowValueTokensContainer)
                    toggleVisibilityOfLowValueTokensContainer(show: isExpanded)
                    lowValueTokensContainer.snp.makeConstraints { make in
                        make.top.equalTo(highValueTokensContainer.snp.bottom).offset(10)
                        make.leading.equalToSuperview()
                        make.trailing.equalToSuperview()
                    }

                    // Loop through each low-value token and append to the low value container
                    for tokenRow in highValueMap[false] ?? [] {
                        lowValueTokensContainer.addSubview(tokenRow)
                        tokenRow.snp.makeConstraints { make in
                            make.top.equalTo(topView.snp.bottom).offset(10)
                            make.leading.equalToSuperview()
                            make.trailing.equalToSuperview()
                            make.height.equalTo(CryptoRow.rowHeight)
                        }
                        topView = tokenRow
                    }

                    // Insert the expand / collapse row at the end of the list
                    if highValueMap[true] != nil, !highValueMap[true]!.isEmpty {
                        expandCollapseRow = appendExpandCollapseRow(to: containerView)
                    }
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

    static func calculatedHeight(wallet: EthereumWallet, cryptoType: CryptoType, isExpanded: Bool) -> CGFloat {
        var height: CGFloat = 0

        switch cryptoType {
        case .ethereum:
            height = 70
        case .erc20:
            var tokens: [Token]?
            var expandHeight: Int

            if let valuableTokens = wallet.valuableTokens, !valuableTokens.isEmpty {
                tokens = isExpanded ? wallet.tokens : wallet.valuableTokens
                expandHeight = (wallet.nonValuableTokens?.count ?? 0) > 0 ? CryptoRow.rowHeight : 0
            } else {
                tokens = wallet.nonValuableTokens ?? []
                expandHeight = 0
            }

            let tokensCount = Int(tokens?.count ?? 0)
            height = CGFloat(expandHeight + calculateHeightForRows(tokensCount))
        }

        return height
    }

    static func calculateHeightForRows(_ tokenCount: Int) -> Int {
        return 20 + Int(tokenCount * (CryptoRow.rowHeight + 10))
    }

    private func toggleVisibilityOfLowValueTokensContainer(show: Bool) {
        lowValueTokensContainer.alpha = show ? 1.0 : 0.0
        lowValueTokensContainer.transform = show ? CGAffineTransform.identity : CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
    }

    private func appendExpandCollapseRow(to container: UIView) -> ExpandCollapseRow {
        var walletTotal: Double?
        if let lowValueTokens = wallet.nonValuableTokens {
            walletTotal = Double(lowValueTokens.reduce(0) { $0 + ($1.fiatBalance ?? 0) })
        }

        let expandCollapseRow = ExpandCollapseRow(isExpanded: isExpanded, walletTotal: walletTotal)
        container.addSubview(expandCollapseRow)
        expandCollapseRow.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(CryptoRow.rowHeight)
        }

        return expandCollapseRow
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

private class ExpandCollapseRow: UIView {
    private let chevronImageView = UIImageView()
    private let expandCollapseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hexString: "#272727")
        return label
    }()

    private let walletTotalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hexString: "#272727")
        label.textAlignment = .right
        return label
    }()

    var isExpanded: Bool = false {
        didSet {
            chevronImageView.image = UIImage(named: isExpanded ? "chevronCircleUp" : "chevronCircleDown")
        }
    }

    init(isExpanded: Bool, walletTotal: Double?) {
        super.init(frame: .zero)
        self.isExpanded = isExpanded

        // Chevron Circle Image
        chevronImageView.image = UIImage(named: isExpanded ? "chevronCircleUp" : "chevronCircleDown")
        addSubview(chevronImageView)
        chevronImageView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }

        // Expand / collapse label
        expandCollapseLabel.text = "Other Balances"
        addSubview(expandCollapseLabel)
        expandCollapseLabel.snp.makeConstraints { make in
            make.leading.equalTo(chevronImageView.snp.trailing).offset(15)
            make.bottom.equalTo(chevronImageView.snp.bottom)
        }

        // Total amount label
        if let walletTotal = walletTotal {
            fiatNumberFormatter.maximumFractionDigits = 0
            walletTotalLabel.text = "~" + (fiatNumberFormatter.string(from: walletTotal as NSNumber) ?? "")
            addSubview(walletTotalLabel)
            walletTotalLabel.snp.makeConstraints { make in
                make.top.equalTo(expandCollapseLabel.snp.top)
                make.trailing.equalToSuperview().offset(-15)
                make.bottom.equalTo(chevronImageView.snp.bottom)
            }
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class CryptoRow: UIView {
    static let rowHeight = 40

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

        var tokenRate = "No Price"
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

        var tokenName = "No Name"

        if let name = name {
            if name.count > 25 {
                tokenName = name.prefix(25) + " ..."
            } else {
                tokenName = name
            }

            if name == "" {
                tokenName = "No Name"
            }
        }

        tokenNameLabel.text = tokenName
        addSubview(tokenNameLabel)
        tokenNameLabel.snp.makeConstraints { make in
            make.height.equalTo(rateLabel)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalTo(rateLabel.snp.leading).offset(-10)
            make.top.equalTo(rateLabel)
        }

        var cryptoBalance = "0.00"

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
        }

        if let balance = balance {
            if let cryptoBalanceString = cryptoNumberFormatter.string(from: balance as NSNumber) {
                cryptoBalance = "\(cryptoBalanceString)"
            }
        }

        let combination = NSMutableAttributedString()

        let cryptoAmountAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        let cryptoSymbolAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]

        let partOne = NSMutableAttributedString(string: "\(String(cryptoBalance))", attributes: cryptoAmountAttributes)
        combination.append(partOne)

        if let symbol = symbol {
            let partTwo = NSMutableAttributedString(string: " \(symbol)", attributes: cryptoSymbolAttributes)
            combination.append(partTwo)
        }

        cryptoBalanceLabel.attributedText = combination

        addSubview(cryptoBalanceLabel)
        cryptoBalanceLabel.snp.makeConstraints { make in
            make.height.equalTo(iconImageView).multipliedBy(0.5)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.bottom.equalTo(iconImageView).offset(2)
        }

        fiatBalanceLabel.textAlignment = .right
        fiatBalanceLabel.contentMode = .top
        fiatBalanceLabel.text = "$0"
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
