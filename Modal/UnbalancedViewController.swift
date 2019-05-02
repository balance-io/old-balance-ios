//
//  UnbalancedViewController.swift
//  Balance
//
//  Created by Jamie Rumbelow on 02/05/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class UnbalancedViewController: UIViewController {
    private let unbalancedImageView: UIImageView = UIImageView(image: UIImage(named: "unbalanced"))
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = UIColor(hexString: "#191817")
        titleLabel.text = "We're a little unbalanced"
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 17)
        subtitleLabel.textColor = UIColor(hexString: "#191817")
        subtitleLabel.numberOfLines = 2
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "It looks like we don't have an internet connection. Please connect and try again."
        return subtitleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "#FBFBFB")
        
        view.addSubview(unbalancedImageView)
        unbalancedImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-85)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(80)
        }
    }
}


