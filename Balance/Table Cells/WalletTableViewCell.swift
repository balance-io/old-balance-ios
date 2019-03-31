import UIKit
import SnapKit

class WalletTableViewCell: UITableViewCell {
    var wallet: EthereumWallet? {
        didSet {
            guard let walletItem = wallet else {
                return
            }
            walletWasSet(walletItem: walletItem)
        }
    }

    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        view.layer.borderColor = UIColor(hexString: "#EEEEEE")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor(hexString: "#fbfbfb")

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            // NOTE: Setting priority to less than 1000 on the top and bottom constraints prevents a constraint error when removing the cell
            make.top.equalToSuperview().offset(10).priority(999)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-10).priority(999)
        }

        self.renderTableViewCellContentFor(containerView: containerView)

        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
    }

    internal func renderTableViewCellContentFor(containerView: UIView) {
        fatalError("unimplemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView?.backgroundColor = selected ? .red : nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }

    internal func walletWasSet(walletItem: EthereumWallet) {
        addressLabel.text = walletItem.address
    }
}
