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
            if let identifier = cdpItem.identifier {
//                profileImageView.image = UIImage(named: name)
//                "\(CDPs[indexPath.row].identifier!)"
                identityLabel.text = "\(identifier)"
            }
            
            if let ratio = cdpItem.ratio {
                ratioLabel.text = "\(String(format:"%.2f", ratio))%"
            }
            
            if let pip = cdpItem.pip {
                pipLabel.text = "\(String(format:"%.2f", pip))%"
            }
            
            if let art = cdpItem.art {
                artLabel.text = "\(String(format:"%.2f", art)) DAI Debt"
            }
            
            if let ink = cdpItem.ink {
                inkLabel.text = "\(String(format:"%.2f", ink)) ETH Locked"
            }
            
            if let liqPrice = cdpItem.liqPrice {
                
                liqPriceLabel.text = "$\(String(format:"%.2f", liqPrice)) "
            }
            
//            if let country = contactItem.country {
//                countryImageView.image = UIImage(named: country)
//            }
        }
    }
    
    //    let profileImageView:UIImageView = {
    //        let img = UIImageView()
    //        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
    //        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
    //        img.layer.cornerRadius = 35
    //        img.clipsToBounds = true
    //        return img
    //    }()
    
    let identityLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textColor =  _ColorLiteralType(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratioLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        //        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
        //        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pipLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        //        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
        //        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
//        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
//        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let inkLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
//        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
//        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let liqPriceLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        //        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
        //        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    //    let countryImageView:UIImageView = {
    //        let img = UIImageView()
    //        img.contentMode = .scaleAspectFill // without this your image will shrink and looks ugly
    //        img.translatesAutoresizingMaskIntoConstraints = false
    //        img.layer.cornerRadius = 13
    //        img.clipsToBounds = true
    //        return img
    //    }()

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.backgroundColor = .red
        
//        self.contentView.addSubview(profileImageView)
//        containerView.backgroundColor = .green
//        containerView.leftAnchor.constraint(equalToSystemSpacingAfter: self.view.leftAnchor, multiplier: 1).isActive = true
//        containerView.rightAnchor.constraint(equalToSystemSpacingAfter: self.rightAnchor, multiplier: 0).isActive = true
//        containerView.frame.size.height = 50
        containerView.addSubview(identityLabel)
        containerView.addSubview(liqPriceLabel)
        containerView.addSubview(artLabel)
        containerView.addSubview(inkLabel)
        
        self.contentView.addSubview(containerView)
        
//        self.contentView.addSubview(countryImageView)
        
        
        //cdpsTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        //cdpsTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        //cdpsTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        //cdpsTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        
        
//        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
//        containerView.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
//        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
//        containerView.widthAnchor.constraint(equalToConstant: 300)
//        containerView.heightAnchor.constraint(equalToConstant: 100)
        
//        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 300)
        containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:0).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:0).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
//        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
//        identityLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
//        identityLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
//        identityLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        liqPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        liqPriceLabel.topAnchor.constraint(equalTo:self.identityLabel.bottomAnchor).isActive = true
//        liqPriceLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
//        liqPriceLabel.topAnchor.constraint(equalTo:self.identityLabel.bottomAnchor).isActive = true
//        liqPriceLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
        artLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        artLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        inkLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        inkLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        inkLabel.widthAnchor.constraint(equalToConstant:100).isActive = true
//        inkLabel.heightAnchor.constraint(equalToConstant:100).isActive = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    

}
