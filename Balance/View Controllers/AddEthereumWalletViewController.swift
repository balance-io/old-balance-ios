//
//  AddEthereumWalletViewController.swift
//  Balance
//
//  Created by Benjamin Baron on 3/10/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit
import SnapKit

private func newTitleLabel() -> UILabel {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.systemFont(ofSize: 18)
    titleLabel.textColor = UIColor(hexString: "#191817")
    return titleLabel
}

private func newTextFieldContainer() -> UIView {
    let textFieldContainer = UIView()
    textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
    textFieldContainer.backgroundColor = .white
    textFieldContainer.layer.cornerRadius = 8
    textFieldContainer.layer.borderColor = UIColor(hexString: "#43464B")?.cgColor
    textFieldContainer.layer.borderWidth = 1
    return textFieldContainer
}

class AddEthereumWalletViewController: UIViewController {
    let topContainerView: UIView = {
        let topContainerView = UIView()
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.backgroundColor = .white
        topContainerView.layer.cornerRadius = 10
        return topContainerView
    }()
    
    let closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        return closeButton
    }()
    
    let middleContainerView: UIView = {
        let middleContainerView = UIView()
        middleContainerView.translatesAutoresizingMaskIntoConstraints = false
        middleContainerView.backgroundColor = .black
        return middleContainerView
    }()
    
    let scanQRCodeImageView: UIImageView = {
        let scanQRCodeImageView = UIImageView()
        scanQRCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        scanQRCodeImageView.image = UIImage(named: "qrCode")
        return scanQRCodeImageView
    }()
    
    let scanQRCodeLabel: UILabel = {
        let scanQRCodeLabel = UILabel()
        scanQRCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        scanQRCodeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        scanQRCodeLabel.textColor = .white
        scanQRCodeLabel.text = "Scan a QR code"
        return scanQRCodeLabel
    }()
    
    let bottomContainerView: UIView = {
        let bottomContainerView = UIView()
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.backgroundColor = .white
        bottomContainerView.layer.cornerRadius = 10
        return bottomContainerView
    }()
    
    let nameTitleLabel: UILabel = {
        let nameTitleLabel = newTitleLabel()
        nameTitleLabel.text = "Name"
        return nameTitleLabel
    }()
    
    let nameFieldContainer: UIView = newTextFieldContainer()
    
    let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.font = UIFont.systemFont(ofSize: 19)
        nameTextField.textColor = UIColor(hexString: "#3C4252")
        nameTextField.minimumFontSize = 8;
        nameTextField.adjustsFontSizeToFitWidth = true;
        nameTextField.autocorrectionType = .no
        nameTextField.spellCheckingType = .no
        return nameTextField
    }()
    
    let addressTitleLabel: UILabel = {
        let addressTitleLabel = newTitleLabel()
        addressTitleLabel.text = "Ethereum Wallet Address"
        return addressTitleLabel
    }()
    
    let addressFieldContainer: UIView = newTextFieldContainer()
    
    let addressTextField: UITextField = {
        let addressTextField = UITextField()
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        addressTextField.placeholder = "Address starting with 0x or ENS"
        addressTextField.font = UIFont.systemFont(ofSize: 15)
        addressTextField.textColor = UIColor(hexString: "#3C4252")
        addressTextField.minimumFontSize = 8;
        addressTextField.adjustsFontSizeToFitWidth = true;
        addressTextField.autocorrectionType = .no
        addressTextField.autocapitalizationType = .none
        addressTextField.spellCheckingType = .no
        return addressTextField
    }()
    
    let pasteButton: UIButton = {
        let pasteButton = UIButton()
        pasteButton.translatesAutoresizingMaskIntoConstraints = false
        pasteButton.backgroundColor = UIColor(hexString: "#0E76FD")
        pasteButton.layer.cornerRadius = 14.5
        pasteButton.setImage(UIImage(named: "pasteWhite"), for: .normal)
        pasteButton.setTitle("Paste", for: .normal)
        pasteButton.setTitleColor(.white, for: .normal)
        pasteButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return pasteButton
    }()
    
    let includeInBalanceTitleLabel: UILabel = {
        let includeInBalanceTitleLabel = newTitleLabel()
        includeInBalanceTitleLabel.text = "Include in total balance"
        return includeInBalanceTitleLabel
    }()
    
    let includeInBalanceSwitch: UISwitch = {
        let includeInBalanceSwitch = UISwitch()
        includeInBalanceSwitch.translatesAutoresizingMaskIntoConstraints = false
        return includeInBalanceSwitch
    }()
    
    let addButton: UIButton = {
        let addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = UIColor(red: 57.0/255.0, green: 64.0/255.0, blue: 82.0/255.0, alpha: 0.25)
        addButton.layer.cornerRadius = 14
        addButton.setTitle("Add wallet to watchlist", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.setImage(UIImage(named: "ethLogoWhite"), for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return addButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        //
        // Top Container
        //
        
        view.addSubview(topContainerView)
        topContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        topContainerView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        //
        // Bottom Container
        //
        
        view.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(370)
        }
        
        bottomContainerView.addSubview(nameTitleLabel)
        nameTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(14)
        }
        
        bottomContainerView.addSubview(nameFieldContainer)
        nameFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(7)
            make.trailing.equalToSuperview().offset(-14)
            make.height.equalTo(53)
        }
        
        nameFieldContainer.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview()
        }
        
        bottomContainerView.addSubview(addressTitleLabel)
        addressTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameFieldContainer.snp.bottom).offset(19)
            make.leading.equalTo(nameTitleLabel)
        }
        
        bottomContainerView.addSubview(addressFieldContainer)
        addressFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameFieldContainer)
            make.trailing.equalTo(nameFieldContainer)
            make.height.equalTo(nameFieldContainer)
        }
        
        addressFieldContainer.addSubview(pasteButton)
        pasteButton.snp.makeConstraints { make in
            make.height.equalTo(29)
            make.width.equalTo(90)
            make.trailing.equalToSuperview().offset(-11)
            make.centerY.equalToSuperview()
        }
        pasteButton.imageView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(11)
            make.centerY.equalToSuperview()
        }
        
        addressFieldContainer.addSubview(addressTextField)
        addressTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalTo(pasteButton.snp.leading).offset(-14)
            make.bottom.equalToSuperview()
        }
        
        bottomContainerView.addSubview(includeInBalanceTitleLabel)
        includeInBalanceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(addressFieldContainer.snp.bottom).offset(19)
            make.leading.equalTo(nameTitleLabel)
        }
        
        bottomContainerView.addSubview(includeInBalanceSwitch)
        includeInBalanceSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(includeInBalanceTitleLabel)
            make.trailing.equalToSuperview().offset(-14)
        }
        
        bottomContainerView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(includeInBalanceSwitch.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.height.equalTo(59)
        }
        addButton.imageView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }
        
        //
        // Middle Container
        //
        
        view.insertSubview(middleContainerView, belowSubview: topContainerView)
        middleContainerView.snp.makeConstraints { make in
            make.top.equalTo(topContainerView.snp.bottom).offset(-10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(bottomContainerView.snp.top).offset(10)
        }
        
        middleContainerView.addSubview(scanQRCodeImageView)
        scanQRCodeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        middleContainerView.addSubview(scanQRCodeLabel)
        scanQRCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(scanQRCodeImageView.snp.bottom).offset(14)
            make.centerX.equalTo(scanQRCodeImageView)
        }
    }
    
    @objc private func closeAction() {
        self.dismiss(animated: true)
    }
}
