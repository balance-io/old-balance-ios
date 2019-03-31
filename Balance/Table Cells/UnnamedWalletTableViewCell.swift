import SnapKit
import UIKit

class UnnamedWalletTableViewCell: WalletTableViewCell {
    override func renderTableViewCellContentFor(containerView: UIView) {
        containerView.addSubview(addressLabel)
        addressLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
