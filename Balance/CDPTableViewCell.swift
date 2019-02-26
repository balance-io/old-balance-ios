//
//  CDPTableViewCell.swift
//  Balance
//
//  Created by Richard Burton on 21/02/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit


class CDPTableViewCell: UITableViewCell {
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.selectedBackgroundView = UIView()
//        self.selectionStyle = .none // you can also take this line out
//        // Initialization code
//    }
    
    var cdp:CDP? {
        didSet {
            guard let cdpItem = cdp else {return}
//            let largeNumber = 31908551587
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.maximumFractionDigits = 0
//            numberFormatter.string(from: NSNumber(value:largeNumber))
            
            if let identifier = cdpItem.identifier {
//                profileImageView.image = UIImage(named: name)
//                "\(CDPs[indexPath.row].identifier!)"
                identityLabel.text = "Maker CDP #\(identifier)"
            }
            
            if let ratio = cdpItem.ratio {
//                ratioLabel.textColor
                
                if ratio < 150.00 {
                    ratioLabel.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.5)
                } else if ratio < 200.00 {
                    ratioLabel.backgroundColor = .red
                } else if ratio < 250.00 {
                    ratioLabel.backgroundColor = .orange
                } else if ratio > 300.00 {
                    ratioLabel.backgroundColor = .green
                }
//
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
                    //                pipLabel.text = "/$\(String(format:"%.2f", pip))"
                
                    liqPriceLabel.text = "$\(String(format:"%.0f", pip)) / \(String(format:"%.0f", liqPrice))"
                }
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        label.font.weigh
//        label.textColor =  _ColorLiteralType(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    let myLayer = CALayer()
//    let myImage = UIImage(named: "star")?.cgImage
//    myLayer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//    myLayer.contents = myImage
//    myView.layer.addSublayer(myLayer)
    
//    let image = UIImage(named: "star")
//    let imageView = UIImageView(image: image!)
//    imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//    myView.addSubview(imageView)
    
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
//        imageView.backgroundColor = .red
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
//        imageView.backgroundColor = .red
        return imageView
    }()
    
    let collateralizedTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Collateral"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .red
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
        label.padding = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 4)
        label.textColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
//        label.textColor = .white
//                label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
        //        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pipLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textColor = .white
        //        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
        //        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textColor = .white
//        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
//        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let inkLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textColor = .white
//        label.backgroundColor = .red
//        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
//        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let liqPriceLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .light)
        label.textColor = .white
        //        label.textColor =  _ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)
        //        label.backgroundColor =  _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        
        let darkCardBackgroundColor = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
        view.backgroundColor = darkCardBackgroundColor
//        yourView.layer.cornerRadius = 10
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    let lineView:UIView = {
//        let line = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 2))
        let line = UIView(frame: CGRect())
        // Change UIView background colour
        line.backgroundColor = .white
        line.alpha = 0.8
        
        // Add rounded corners to UIView
        line.layer.cornerRadius = 5
        
        return line
    }()
    
    //    let countryImageView:UIImageView = {
    //        let img = UIImageView()
    //        img.contentMode = .scaleAspectFill // without this your image will shrink and looks ugly
    //        img.translatesAutoresizingMaskIntoConstraints = false
    //        img.layer.cornerRadius = 13
    //        img.clipsToBounds = true
    //        return img
    //    }()



    


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.backgroundColor = .red
        
//        self.contentView.addSubview(profileImageView)
//        containerView.backgroundColor = .green
//        containerView.leftAnchor.constraint(equalToSystemSpacingAfter: self.view.leftAnchor, multiplier: 1).isActive = true
//        containerView.rightAnchor.constraint(equalToSystemSpacingAfter: self.rightAnchor, multiplier: 0).isActive = true
//        containerView.frame.size.height = 50
        
//        //// General Declarations
//        let context = UIGraphicsGetCurrentContext()!
//
//        //// Color Declarations
//        let gradientColor = UIColor(red: 0.227, green: 0.251, blue: 0.282, alpha: 1.000)
//        let gradientColor3 = UIColor(red: 0.176, green: 0.196, blue: 0.220, alpha: 1.000)
//
//        //// Gradient Declarations
//        let gradient = CGGradient(colorsSpace: nil, colors: [gradientColor.cgColor, gradientColor3.cgColor] as CFArray, locations: [0, 1])!
//
//        //// Rectangle Drawing
//        let rectangleRect = CGRect(x: frame.minX + 8, y: frame.minY + 6, width: frame.width - 16, height: frame.height - 12)
//        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 6)
//        context.saveGState()
//        rectanglePath.addClip()
//        context.drawLinearGradient(gradient,
//                                   start: CGPoint(x: rectangleRect.midX, y: rectangleRect.minY),
//                                   end: CGPoint(x: rectangleRect.midX, y: rectangleRect.maxY),
//                                   options: [])
//        context.restoreGState()
        
//        let line = UIView(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: 2))
//
//        // Change UIView background colour
//        line.backgroundColor = .white
//        line.alpha = 0.8
//
//        // Add rounded corners to UIView
//        line.layer.cornerRadius = 5
        
        // Add border to UIView
//        myNewView.layer.borderWidth=0
        
        // Change UIView Border Color to Red
//        myNewView.layer.borderColor = UIColor.red.cgColor
        
        // Add UIView as a Subview
        containerView.addSubview(lineView)
        
//        containerView.addSubview(context)
        containerView.addSubview(identityLabel)
        containerView.addSubview(ethCircleImageView)
        containerView.addSubview(mkrSquircle)
        containerView.addSubview(daiCircle)
        containerView.addSubview(checkCircle)
//        containerView.addSubview(checkCircle)
        containerView.addSubview(collateralizedTitleLabel)
        containerView.addSubview(debtTitleLabel)
        containerView.addSubview(positionTitleLabel)
        containerView.addSubview(ratioLabel)
        containerView.addSubview(pipLabel)
        containerView.addSubview(artLabel)
        containerView.addSubview(inkLabel)
        containerView.addSubview(liqPriceLabel)
        
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
        containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
//        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
//        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
//
//        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        mkrSquircle.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 15).isActive = true
        mkrSquircle.leadingAnchor.constraint(equalTo:containerView.leadingAnchor, constant: 15).isActive = true
        
//        lineView.topAnchor.constraint(equalTo: mkrSquircle.bottomAnchor, constant: 3).isActive = true
//        lineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        ethCircleImageView.topAnchor.constraint(equalTo:mkrSquircle.bottomAnchor, constant: 12).isActive = true
        ethCircleImageView.centerXAnchor.constraint(equalTo:mkrSquircle.centerXAnchor, constant: 0).isActive = true
        
        daiCircle.topAnchor.constraint(equalTo:ethCircleImageView.bottomAnchor, constant: 12).isActive = true
        daiCircle.centerXAnchor.constraint(equalTo:ethCircleImageView.centerXAnchor, constant: 0).isActive = true
        
        checkCircle.topAnchor.constraint(equalTo:daiCircle.bottomAnchor, constant: 12).isActive = true
        checkCircle.centerXAnchor.constraint(equalTo:ethCircleImageView.centerXAnchor, constant: 0).isActive = true
        
        
        identityLabel.centerYAnchor.constraint(equalTo:mkrSquircle.centerYAnchor, constant: 0).isActive = true
        identityLabel.leadingAnchor.constraint(equalTo:mkrSquircle.trailingAnchor, constant: 5).isActive = true
        
        collateralizedTitleLabel.centerYAnchor.constraint(equalTo:self.ethCircleImageView.centerYAnchor, constant: 0).isActive = true
        collateralizedTitleLabel.leadingAnchor.constraint(equalTo:self.ethCircleImageView.trailingAnchor, constant: 5).isActive = true

        debtTitleLabel.topAnchor.constraint(equalTo: daiCircle.topAnchor, constant: 0).isActive = true
        debtTitleLabel.leadingAnchor.constraint(equalTo: collateralizedTitleLabel.leadingAnchor, constant: 0).isActive = true

        positionTitleLabel.topAnchor.constraint(equalTo: checkCircle.topAnchor, constant: 0).isActive = true
        positionTitleLabel.leadingAnchor.constraint(equalTo: debtTitleLabel.leadingAnchor, constant: 0).isActive = true
        
        
//        ratioLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        
        ratioLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
//        ratioLabel.centerYAnchor.constraint(equalTo: identityLabel.centerYAnchor, constant: 0).isActive = true
        ratioLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        
        inkLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        inkLabel.centerYAnchor.constraint(equalTo: collateralizedTitleLabel.centerYAnchor, constant: 0).isActive = true
        
        artLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        artLabel.centerYAnchor.constraint(equalTo: debtTitleLabel.centerYAnchor, constant: 0).isActive = true
        
        liqPriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        liqPriceLabel.centerYAnchor.constraint(equalTo: positionTitleLabel.centerYAnchor, constant: 0).isActive = true
        
//        pipLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
//        liqPriceLabel.topAnchor.constraint(equalTo:self.identityLabel.bottomAnchor).isActive = true
//        liqPriceLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
//        liqPriceLabel.topAnchor.constraint(equalTo:self.identityLabel.bottomAnchor).isActive = true
//        liqPriceLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        

        

//        inkLabel.widthAnchor.constraint(equalToConstant:100).isActive = true
//        inkLabel.heightAnchor.constraint(equalToConstant:100).isActive = true
        
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView!.backgroundColor = selected ? .red : nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    

}
