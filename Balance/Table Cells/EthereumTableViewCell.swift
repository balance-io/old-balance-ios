import UIKit

class EtherTableViewCell: UITableViewCell {
    
//    var wallet:EthereumWallet? {
//        didSet {
//            guard let walletItem = wallet else {return}
//
//            if let name = walletItem.name {
//                nameLabel.text = "\(String(name))"
//            } else {
//                nameLabel.text = "No Name"
//            }
//
//            if let address = walletItem.address {
//                addressLabel.text = "\(String(address))"
//            }
//        }
//    }
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
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
        
        containerView.addSubview(lineView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(addressLabel)
        
        self.contentView.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
        self.contentView.addSubview(containerView)
        
        containerView.heightAnchor.constraint(equalToConstant: 50)
        containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        //        nameLabel.centerYAnchor.constraint(equalTo:containerView.centerYAnchor, constant: 0).isActive = true
        nameLabel.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 15).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:containerView.leadingAnchor, constant: 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor, constant: 15).isActive = true
        //        nameLabel.widthAnchor.constraint(equalTo:containerView.widthAnchor, multiplier: 0.8).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo:nameLabel.bottomAnchor, constant: 5).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo:nameLabel.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo:nameLabel.trailingAnchor).isActive = true
        
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

