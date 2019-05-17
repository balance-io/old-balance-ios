import CoreData
import SwiftEntryKit
import UIKit

typealias RefreshBlock = () -> Void
class BalanceContentViewController: UITableViewController {
    enum Section: Int {
        case cdp = 0
        case ethereum = 1
        case erc20 = 2
    }

    var sections: [Section] {
        var sectionList: [Section] = []

        if showCDPSection() {
            sectionList.append(Section.cdp)
        }

        sectionList.append(Section.ethereum)

        if showTokensSection() {
            sectionList.append(Section.erc20)
        }

        print("computing sections: \(sectionList.count) sections")

        return sectionList
    }

    var ethereumWallet: EthereumWallet?
    var erc20TableCell: CryptoBalanceTableViewCell?
    var refreshBlock: RefreshBlock?

    private var expandedIndexPath: IndexPath?

    private let cdpCellReuseIdentifier = "cdpCell"
    private lazy var cryptoCellReuseIdentifier: String = {
        // Use the memory address in the identifier so we only respond to cell notifications for this view controller
        let memAddress = unsafeBitCast(self, to: Int.self)
        return "\(memAddress) cryptoCell"
    }()

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hexString: "#fbfbfb")

        tableView.backgroundColor = UIColor(hexString: "#fbfbfb")
        tableView.separatorStyle = .none
        tableView.register(CDPBalanceTableViewCell.self, forCellReuseIdentifier: cdpCellReuseIdentifier)

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reload), for: .valueChanged)
        tableView.refreshControl = refresh

        setupNavigation()

        if showTokensSection() {
            preloadErc20Cell()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(cellExpanded(_:)), name: ExpandableTableViewCell.Notifications.expanded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cellCollapsed(_:)), name: ExpandableTableViewCell.Notifications.collapsed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startedLoadingBalances), name: BalanceViewController.Notifications.startedLoadingBalances, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedLoadingBalances), name: BalanceViewController.Notifications.finishedLoadingBalances, object: nil)
    }

    private func setupNavigation() {
        navigationItem.title = ""
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = .white
            navigationBar.isTranslucent = false
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }

    @objc private func reload() {
        refreshBlock?()
    }

    private func reloadTableCellHeights() {
        // "hack" to reload the sizes without loading the table cell again
        // Note it's not really a hack, it's actually the recommended way to do this, it just feels hackish since Apple
        // doesn't provide a proper method for this
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    @objc private func cellExpanded(_ notification: Notification) {
        if let userInfo = notification.userInfo, userInfo[ExpandableTableViewCell.Notifications.Keys.reuseIdentifier] as? String == cryptoCellReuseIdentifier, let indexPath = userInfo[ExpandableTableViewCell.Notifications.Keys.indexPath] as? IndexPath {
            expandedIndexPath = indexPath
            reloadTableCellHeights()
        }
    }

    @objc private func cellCollapsed(_ notification: Notification) {
        if let userInfo = notification.userInfo, userInfo[ExpandableTableViewCell.Notifications.Keys.reuseIdentifier] as? String == cryptoCellReuseIdentifier {
            expandedIndexPath = nil
            reloadTableCellHeights()
        }
    }

    @objc private func startedLoadingBalances() {
        tableView.refreshControl?.beginRefreshingManually()
    }

    @objc private func finishedLoadingBalances() {
        tableView.refreshControl?.endRefreshing()
    }

    // MARK: - Table View -

    private func preloadErc20Cell() {
        let indexPath = indexPathForSectionType(.erc20)!
        let isExpanded = ethereumWallet!.isAlwaysExpanded() || (indexPath == expandedIndexPath)
        erc20TableCell = CryptoBalanceTableViewCell(withIdentifier: cryptoCellReuseIdentifier, wallet: ethereumWallet!, cryptoType: .erc20, isExpanded: isExpanded, indexPath: indexPath)
    }

    func reloadData() {
        if showTokensSection() {
            preloadErc20Cell()
        }

        tableView.reloadData()
    }

    // MARK: - Dynamic Sections -

    func showCDPSection() -> Bool {
        guard let isEmpty = ethereumWallet?.CDPs?.isEmpty, isEmpty == false else {
            return false
        }

        return true
    }

    func showTokensSection() -> Bool {
        guard let count = ethereumWallet?.tokens?.count, count > 0 else {
            return false
        }

        return true
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    func indexPathForSectionType(_ type: Section) -> IndexPath? {
        if let sectionIndex = sections.firstIndex(of: type) {
            return IndexPath(row: 0, section: sectionIndex)
        }

        return nil
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionEnum: Section = sections[section]

        switch sectionEnum {
        case .ethereum:
            return ethereumWallet != nil ? 1 : 0
        case .erc20:
            return 1
        case .cdp:
            return ethereumWallet?.CDPs?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isExpanded = ethereumWallet!.isAlwaysExpanded() || (indexPath == expandedIndexPath)
        let sectionEnum: Section = sections[indexPath.section]

        if sectionEnum == .ethereum {
            return CryptoBalanceTableViewCell(withIdentifier: cryptoCellReuseIdentifier, wallet: ethereumWallet!, cryptoType: .ethereum, isExpanded: isExpanded, indexPath: indexPath)
        } else if sectionEnum == .erc20 {
            // Cache this cell to prevent stuttering when scrolling
            return erc20TableCell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cdpCellReuseIdentifier, for: indexPath) as! CDPBalanceTableViewCell
            if let cdp = ethereumWallet?.CDPs?[indexPath.row] {
                cell.cdp = cdp
            }
            return cell
        }
    }

    public override func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 70.0
    }

    public override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView
        if let _view: UIView = tableView.headerView(forSection: section) {
            view = _view
        } else {
//            let dxOffset: CGFloat = 16.0
            view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
        }

        let icon: UIImageView = UIImageView()

        // create our label
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = UIColor(hexString: "#131415")

        let sectionName: String
        let sectionEnum: Section = sections[section]

        switch sectionEnum {
        case .cdp:
            sectionName = NSLocalizedString("Maker Loans", comment: "")
            icon.image = UIImage(named: "makerSection")
        case .ethereum:
            sectionName = NSLocalizedString("Ethereum", comment: "")
            icon.image = UIImage(named: "ethereumSection")
        case .erc20:
            sectionName = NSLocalizedString("Tokens", comment: "")
            icon.image = UIImage(named: "erc20Section")
        }

        label.text = sectionName
//        label.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize() + 4.0)

        view.addSubview(icon)

        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }

        label.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(label)

        view.backgroundColor = .white

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: -1)
        view.layer.shadowRadius = 9
        view.layer.zPosition = 200

        view.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 10, width: tableView.bounds.width, height: 20)).cgPath
        view.layer.cornerRadius = 10
        // view.layer.shouldRasterize = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        label.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(10)
//            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        return view
    }

    override func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 30
    }

    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: UIView
        if let _view: UIView = tableView.footerView(forSection: section) {
            view = _view
        } else {
            view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        }

        let subview = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 15))

        subview.backgroundColor = .white

        subview.layer.shadowColor = UIColor.black.cgColor
        subview.layer.shadowOpacity = 0.3
        subview.layer.shadowOffset = CGSize(width: 1, height: 1)
        subview.layer.shadowRadius = 8

        subview.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 10, width: tableView.bounds.width, height: 5)).cgPath
        subview.layer.zPosition = -100
        subview.layer.cornerRadius = 10
        // subview.layer.shouldRasterize = true
        subview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.addSubview(subview)

        return view
    }

    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let ethereumWallet = ethereumWallet else {
            return 0
        }

        let isExpanded = (indexPath == expandedIndexPath)
        let sectionEnum: Section = sections[indexPath.section]

        if sectionEnum == .ethereum {
            return CryptoBalanceTableViewCell.calculatedHeight(wallet: ethereumWallet, cryptoType: .ethereum, isExpanded: isExpanded)
        } else if sectionEnum == .erc20 {
            let isErc20Expanded = ethereumWallet.isAlwaysExpanded() ? false : isExpanded
            return CryptoBalanceTableViewCell.calculatedHeight(wallet: ethereumWallet, cryptoType: .erc20, isExpanded: isErc20Expanded)
        } else {
            // CDP cell height
            return 70
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let sectionEnum: Section = sections[indexPath.section]

        guard sectionEnum == .cdp else {
            return
        }

        guard let cdp = ethereumWallet?.CDPs?[indexPath.row] else {
            return
        }

        var attributes = EKAttributes()
        attributes = .centerFloat
        attributes.name = "CDP Info"
        attributes.hapticFeedbackType = .success
        attributes.popBehavior = .animated(animation: .translation)
        attributes.entryBackground = .color(color: .black)
        attributes.roundCorners = .all(radius: 20)
        attributes.border = .none
        attributes.statusBar = .hidden
        attributes.screenBackground = .color(color: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.8))
        attributes.positionConstraints.rotation.isEnabled = false
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 2))
        attributes.statusBar = .ignored
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.positionConstraints.rotation.isEnabled = false
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.95)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)

        let cdpInfoView = CDPInfoView(cdp: cdp)
        SwiftEntryKit.display(entry: cdpInfoView, using: attributes)
    }
}
