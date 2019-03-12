//
//  SettingsTableViewCell.swift
//  Balance
//
//  Created by Benjamin Baron on 3/11/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell {
    var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .white : .gray
            contentView.alpha = isEnabled ? 1.0 : 0.3
        }
    }
    
    let sideLabel: UILabel = {
        let sideLabel = UILabel()
        sideLabel.translatesAutoresizingMaskIntoConstraints = false
        sideLabel.font = UIFont.systemFont(ofSize: 17)
        sideLabel.textColor = UIColor(hexString: "#8E8E93")
        return sideLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        isEnabled = true
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        textLabel?.textColor = .black
        textLabel?.font = UIFont.systemFont(ofSize: 17.4)
        
        addSubview(sideLabel)
        sideLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("unimplemented")
    }
}
