import UIKit
import AVKit
import SnapKit

private func newTitleLabel() -> UILabel {
    let titleLabel = UILabel()
    titleLabel.font = UIFont.systemFont(ofSize: 18)
    titleLabel.textColor = UIColor(hexString: "#191817")
    return titleLabel
}

private func newOptionalLabel() -> UILabel {
    let optionalLabel = UILabel()
    optionalLabel.font = UIFont.systemFont(ofSize: 14)
    optionalLabel.text = "(optional)"
    optionalLabel.textColor = UIColor(hexString: "#666666")
    return optionalLabel
}

private func newTextFieldContainer() -> UIView {
    let textFieldContainer = UIView()
    textFieldContainer.backgroundColor = .white
    textFieldContainer.layer.cornerRadius = 8
    textFieldContainer.layer.borderColor = UIColor(hexString: "#43464B")?.cgColor
    textFieldContainer.layer.borderWidth = 1
    return textFieldContainer
}

class AddEthereumWalletViewController: UIViewController, UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate {
    private let topContainerView: UIView = {
        let topContainerView = UIView()
        topContainerView.backgroundColor = .white
        topContainerView.layer.cornerRadius = 10
        return topContainerView
    }()

    private let closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        return closeButton
    }()

    private let middleContainerView: UIView = {
        let middleContainerView = UIView()
        middleContainerView.backgroundColor = .black
        return middleContainerView
    }()

    private let cameraPreviewLayer = AVCaptureVideoPreviewLayer()

    private let cameraHighlightBoxLayer: CALayer = {
        let cameraHighlightBoxLayer = CALayer()
        cameraHighlightBoxLayer.borderColor = UIColor.red.cgColor
        cameraHighlightBoxLayer.borderWidth = 2
        cameraHighlightBoxLayer.cornerRadius = 10
        return cameraHighlightBoxLayer
    }()

    private let cameraPreviewView: UIView = {
        let cameraPreviewView = UIView()
        cameraPreviewView.backgroundColor = .black
        return cameraPreviewView
    }()

    private let scanQRCodeImageView: UIImageView = {
        let scanQRCodeImageView = UIImageView()
        scanQRCodeImageView.image = UIImage(named: "qrCode")
        return scanQRCodeImageView
    }()

    private let scanQRCodeLabel: UILabel = {
        let scanQRCodeLabel = UILabel()
        scanQRCodeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        scanQRCodeLabel.textColor = .white
        scanQRCodeLabel.text = "Scan a QR code"
        return scanQRCodeLabel
    }()

    private let bottomContainerView: UIView = {
        let bottomContainerView = UIView()
        bottomContainerView.backgroundColor = .white
        bottomContainerView.layer.cornerRadius = 10
        return bottomContainerView
    }()

    private let addressTitleLabel: UILabel = {
        let addressTitleLabel = newTitleLabel()
        addressTitleLabel.text = "Ethereum Wallet Address"
        return addressTitleLabel
    }()

    private let nameOptionalLabel: UILabel = {
        return newOptionalLabel()
    }()

    private let addressFieldContainer: UIView = newTextFieldContainer()

    private let addressTextField: UITextField = {
        let addressTextField = UITextField()
        addressTextField.placeholder = "Address starting with 0x"
        addressTextField.font = UIFont.systemFont(ofSize: 15)
        addressTextField.textColor = UIColor(hexString: "#3C4252")
        addressTextField.minimumFontSize = 8;
        addressTextField.adjustsFontSizeToFitWidth = true;
        addressTextField.autocorrectionType = .no
        addressTextField.autocapitalizationType = .none
        addressTextField.spellCheckingType = .no
        return addressTextField
    }()
    
    private let addressFieldValidationLabel: UILabel = {
        let addressFieldValidationLabel = UILabel()
        addressFieldValidationLabel.isHidden = true
        addressFieldValidationLabel.font = UIFont.systemFont(ofSize: 14)
        addressFieldValidationLabel.textColor = UIColor(hexString: "#cc0000")
        return addressFieldValidationLabel
    }()

    private let nameTitleLabel: UILabel = {
        let nameTitleLabel = newTitleLabel()
        nameTitleLabel.text = "Name"
        return nameTitleLabel
    }()

    private let nameFieldContainer: UIView = newTextFieldContainer()

    private let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.font = UIFont.systemFont(ofSize: 19)
        nameTextField.textColor = UIColor(hexString: "#3C4252")
        nameTextField.minimumFontSize = 8;
        nameTextField.adjustsFontSizeToFitWidth = true;
        nameTextField.autocorrectionType = .no
        nameTextField.spellCheckingType = .no
        return nameTextField
    }()

    private let pasteButton: UIButton = {
        let pasteButton = UIButton()
        pasteButton.backgroundColor = UIColor(hexString: "#0E76FD")
        pasteButton.layer.cornerRadius = 12
        pasteButton.titleLabel?.textAlignment = .center
        pasteButton.setImage(UIImage(named: "pasteWhite"), for: .normal)
        pasteButton.setTitle("Paste", for: .normal)
        pasteButton.setTitleColor(.white, for: .normal)
        pasteButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return pasteButton
    }()

    private let includeInTotalTitleLabel: UILabel = {
        let includeInTotalTitleLabel = newTitleLabel()
        includeInTotalTitleLabel.text = "Include in total balance"
        return includeInTotalTitleLabel
    }()

    private let includeInTotalSwitch: UISwitch = {
        let includeInTotalSwitch = UISwitch()
        includeInTotalSwitch.isOn = true
        return includeInTotalSwitch
    }()

    private let addButton: UIButton = {
        let addButton = UIButton()
        addButton.layer.cornerRadius = 14
        addButton.setTitle("Add wallet to watchlist", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.setBackgroundImage(UIImage(named: "blueGradientButton"), for: .normal)
        addButton.setImage(UIImage(named: "ethLogoWhite"), for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return addButton
    }()

    // MARK - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

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

        bottomContainerView.addSubview(addressTitleLabel)
        addressTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(14)
        }

        bottomContainerView.addSubview(addressFieldContainer)
        addressFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(7)
            make.trailing.equalToSuperview().offset(-14)
            make.height.equalTo(60)
        }

        addressTextField.delegate = self
        addressFieldContainer.addSubview(addressTextField)
        addressTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview()
        }
        addressTextField.addTarget(self, action: #selector(validate), for: .editingChanged)

        addressFieldContainer.addSubview(pasteButton)
        pasteButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(78)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        pasteButton.imageView?.snp.makeConstraints { make in
            make.width.equalTo(13)
            make.leading.equalToSuperview().offset(9)
            make.centerY.equalToSuperview().offset(-1)
        }
        //TODO: Get the label perfectly centered
        // BEN NOTE: You need to use pasteButton.titleEdgeInsets, constraints will break everything as you probably noticed
        //           Also you'll probably need to calculate the insets based on the screen size in order to get it right on all devices
//        pasteButton.titleLabel?.snp.makeConstraints { make in
//            make.leading.equalTo(pasteButton).offset(30)
//            make.leading.equalToSuperview().offset(30)
//            make.trailing.equalToSuperview().offset(0)
//            make.leading.equalTo(pasteButton.imageView?.snp.trailing ?? pasteButton.snp.leading).offset(100)
            
//        }
        pasteButton.addTarget(self, action: #selector(pasteAction), for: .touchUpInside)
        
        addressFieldContainer.addSubview(addressFieldValidationLabel)
        addressFieldValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(5)
            make.leading.equalTo(addressTextField.snp.leading)
            make.trailing.equalTo(addressTextField.snp.trailing)
        }

        bottomContainerView.addSubview(nameTitleLabel)
        nameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(addressFieldContainer.snp.bottom).offset(25)
            make.leading.equalTo(addressTitleLabel)
        }

        bottomContainerView.addSubview(nameOptionalLabel)
        nameOptionalLabel.snp.makeConstraints { make in
            make.top.equalTo(addressFieldContainer.snp.bottom).offset(21)
            make.trailing.equalToSuperview().offset(-14)
        }

        bottomContainerView.addSubview(nameFieldContainer)
        nameFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(addressFieldContainer)
            make.trailing.equalTo(addressFieldContainer)
            make.height.equalTo(addressFieldContainer)
        }

        nameTextField.delegate = self
        nameFieldContainer.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(pasteButton.snp.leading).offset(-10)
            make.bottom.equalToSuperview()
        }
        
//        bottomContainerView.addSubview(includeInTotalTitleLabel)
//        includeInTotalTitleLabel.snp.makeConstraints { make in
//            make.top.equalTo(addressFieldContainer.snp.bottom).offset(19)
//            make.leading.equalTo(nameTitleLabel)
//        }
        
//        bottomContainerView.addSubview(includeInTotalSwitch)
//        includeInTotalSwitch.snp.makeConstraints { make in
//            make.centerY.equalTo(includeInTotalTitleLabel)
//            make.trailing.equalToSuperview().offset(-14)
//        }
        
        bottomContainerView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
//            make.top.equalTo(includeInTotalSwitch.snp.bottom).offset(10)
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.width.equalTo(381)
            make.height.equalTo(95)
            make.centerX.equalToSuperview()
        }
        addButton.imageView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview().offset(-2)
        }
        addButton.titleEdgeInsets = UIEdgeInsets(top: -2, left: -20, bottom: 0, right: 0)
        addButton.isEnabled = false
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)

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

        middleContainerView.addSubview(cameraPreviewView)
        cameraPreviewView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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

        setupCameraPreviewView()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraPreviewLayer.frame = cameraPreviewView.bounds
    }

    // MARK - Validate -

    @objc private func validate() {
        addButton.isEnabled = false
        
        // Address: don't show error if no content entered
        guard let address = addressTextField.text, address.count > 0 else {
            addressFieldValidationLabel.isHidden = true
            return
        }

        // Address: length should be 42
        guard address.count == 42 else {
            throwValidationError("Wallet address should be 42 characters long")
            return
        }

        // Address: should begin with 0x
        guard address.hasPrefix("0x") else {
            throwValidationError("Wallet address should begin with 0x")
            return
        }

        // Address: should be valid
        guard addressIsValid(address) else {
            throwValidationError("Wallet address is invalid")
            return
        }

        // Address: warn if no transactions
        guard addressHasTransactions(address) else {
            throwValidationWarning("We couldn't find any transactions in this wallet address.\nAre you sure it's correct?")
            return
        }

        // We're valid
        addButton.isEnabled = true
        addressFieldValidationLabel.isHidden = true
    }

    private func addressIsValid(_ address: String) -> Bool {
        // Does the address contain only alphanumeric characters?
        if (address.range(of: "[^a-zA-Z0-9]", options: .regularExpression) != nil) {
            return false
        }

        // Are the address's alpha chars all-lower case or all-upper case?
        if (address == address.lowercased() || address == address.uppercased()) {
            return true
        }
        
        // Does the address match the ERC-55 checksum?
        if (EIP55.test(address)) {
            return true
        }

        return false
    }

    private func addressHasTransactions(_ address: String) -> Bool {
        // @todo
        return true
    }

    private func throwValidationError(_ message: String) {
        addressFieldValidationLabel.isHidden = false
        addressFieldValidationLabel.text = message
    }

    private func throwValidationWarning(_ message: String) {
        print(message)
    }

    // MARK - Button Actions -
    
    //TODO Add a proper function for adding and removing the paste button. This is a hack.
    //TODO Grey out the paste button if the address in the clipboard does not contain an Ethereum address.
    
    
    @objc private func closeAction() {
        dismiss(animated: true)
    }

    @objc private func pasteAction() {
        if let string = UIPasteboard.general.string {
            addressTextField.text = string
            self.pasteButton.isHidden = true
            self.scanQRCodeLabel.isHidden = true
            scanQRCodeImageView.image = UIImage(named: "addressSuccess")
            addressTextField.snp.updateConstraints { make in
                make.trailing.equalToSuperview().offset(-10)
            }
            
            //TODO Grey out the add button if all the conditions for adding are not met.
            validate()
        }
    }

    @objc private func addAction() {
        guard let address = addressTextField.text else {
            return
        }

        let ethereumWallet = EthereumWallet(name: nameTextField.text, address: address, includeInTotal: includeInTotalSwitch.isOn)

        CoreDataHelper.save(ethereumWallet: ethereumWallet)
        NotificationCenter.default.post(name: CoreDataHelper.Notifications.ethereumWalletAdded, object: nil)
    }

    // MARK - Keyboard -
    
    //TODO Fix for 3rd part keyboards

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                print("y: \(self.view.frame.origin.y) keyboardHeight: \(keyboardSize.height)")
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addressTextField {
            nameTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return false
    }

    // MARK - QR Code Scanning -

    private func setupCameraPreviewView() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }

        do {
            let session = AVCaptureSession()

            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)

            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session.addOutput(output)
            output.metadataObjectTypes = output.availableMetadataObjectTypes

            cameraPreviewLayer.session = session
            cameraPreviewLayer.videoGravity = .resizeAspectFill
            cameraPreviewView.layer.addSublayer(cameraPreviewLayer)
            cameraPreviewView.layer.addSublayer(cameraHighlightBoxLayer)
            session.startRunning()
        } catch {
            print("Failed to create AVCaptureSession: \(error)")
        }
    }

    private var lastDetectedString: String?
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var highlightBoxRect = CGRect.zero
        var detectedString: String?

        for metadata in metadataObjects {
            if metadata.type == AVMetadataObject.ObjectType.qr {
                if let barCodeObject = cameraPreviewLayer.transformedMetadataObject(for: metadata) as? AVMetadataMachineReadableCodeObject,
                    let metadata = metadata as? AVMetadataMachineReadableCodeObject {
                    highlightBoxRect = barCodeObject.bounds.insetBy(dx: -10, dy: -10)
                    if let stringValue = metadata.stringValue {
                        detectedString = stringValue
                        break
                    }
                }
            }
        }

        if detectedString != lastDetectedString, var finalDetectedString = detectedString {
            print("Read QR code: \(finalDetectedString)")
            lastDetectedString = finalDetectedString

            // Fix for MetaMask QR codes (and maybe others)
            // TODO support EIP 681 ethereum:<address> is valid
            let prefixes = ["ethereum:"]
            for prefix in prefixes {
                if finalDetectedString.hasPrefix(prefix) {
                    let startIndex = finalDetectedString.index(finalDetectedString.startIndex, offsetBy: prefix.count)
                    finalDetectedString = String(finalDetectedString[startIndex...])
                    break;
                }
            }

            addressTextField.text = finalDetectedString
            self.pasteButton.removeFromSuperview()
            self.scanQRCodeLabel.removeFromSuperview()
            scanQRCodeImageView.image = UIImage(named: "addressSuccess")
            
            addressTextField.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-10)
            }
        }

        cameraHighlightBoxLayer.frame = highlightBoxRect
    }
}
