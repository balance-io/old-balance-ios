import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()

    private let contentView = UIView()

    private let balanceLogoImageView: UIImageView = {
        let balanceLogoImageView = UIImageView()
        balanceLogoImageView.image = UIImage(named: "balanceLogo")
        return balanceLogoImageView
    }()

    private let balanceNameImageView: UIImageView = {
        let balanceNameImageView = UIImageView()
        balanceNameImageView.image = UIImage(named: "balanceName")
        return balanceNameImageView
    }()

    private let wavesImageView: UIImageView = {
        let wavesImageView = UIImageView()
        wavesImageView.image = UIImage(named: "wavesWithoutLogos")
        return wavesImageView
    }()

    private let richardImageView: UIImageView = {
        let richardImageView = UIImageView()
        richardImageView.image = UIImage(named: "richard")
        return richardImageView
    }()

    private let benImageView: UIImageView = {
        let benImageView = UIImageView()
        benImageView.image = UIImage(named: "ben")
        return benImageView
    }()

    private let wolffanImageView: UIImageView = {
        let wolffanImageView = UIImageView()
        wolffanImageView.image = UIImage(named: "wolffan")
        return wolffanImageView
    }()

    private let jamierumbelowImageView: UIImageView = {
        let jamierumbelowImageView = UIImageView()
        jamierumbelowImageView.image = UIImage(named: "jamierumbelow")
        return jamierumbelowImageView
    }()

    private let joinTitleLabel: UILabel = {
        let joinTitleLabel = UILabel()
        joinTitleLabel.font = UIFont.systemFont(ofSize: 24)
        joinTitleLabel.textColor = UIColor(hexString: "#191817")
        joinTitleLabel.text = "Join the community"
        return joinTitleLabel
    }()

    private let joinSubtitleLabel: UILabel = {
        let joinSubtitleLabel = UILabel()
        joinSubtitleLabel.font = UIFont.systemFont(ofSize: 17)
        joinSubtitleLabel.textColor = UIColor(hexString: "#191817")
        joinSubtitleLabel.numberOfLines = 2
        joinSubtitleLabel.lineBreakMode = .byWordWrapping
        joinSubtitleLabel.textAlignment = .center
        joinSubtitleLabel.text = "Creating interfaces for the open source financial system"
        return joinSubtitleLabel
    }()

    private let mediumButton: UIButton = {
        let mediumButton = UIButton()
        mediumButton.setBackgroundImage(UIImage(named: "socialButtonBackground"), for: .normal)
        mediumButton.setImage(UIImage(named: "mediumLogo"), for: .normal)
        mediumButton.setTitle("Medium", for: .normal)
        mediumButton.setTitleColor(UIColor(hexString: "#191817"), for: .normal)
        mediumButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.4)
        return mediumButton
    }()

    private let discordButton: UIButton = {
        let discordButton = UIButton()
        discordButton.setBackgroundImage(UIImage(named: "socialButtonBackground"), for: .normal)
        discordButton.setImage(UIImage(named: "discordLogo"), for: .normal)
        discordButton.setTitle("Discord", for: .normal)
        discordButton.setTitleColor(UIColor(hexString: "#191817"), for: .normal)
        discordButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.4)
        return discordButton
    }()

    private let twitterButton: UIButton = {
        let twitterButton = UIButton()
        twitterButton.setBackgroundImage(UIImage(named: "socialButtonBackground"), for: .normal)
        twitterButton.setImage(UIImage(named: "twitterLogo"), for: .normal)
        twitterButton.setTitle("Twitter", for: .normal)
        twitterButton.setTitleColor(UIColor(hexString: "#191817"), for: .normal)
        twitterButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.4)
        return twitterButton
    }()

    private let githubButton: UIButton = {
        let githubButton = UIButton()
        githubButton.setBackgroundImage(UIImage(named: "socialButtonBackground"), for: .normal)
        githubButton.setImage(UIImage(named: "githubLogo"), for: .normal)
        githubButton.setTitle("GitHub", for: .normal)
        githubButton.setTitleColor(UIColor(hexString: "#191817"), for: .normal)
        githubButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.4)
        return githubButton
    }()

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#fbfbfb")

        // Setup scroll view
        // -----------------------------------------

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        if UIScreen.main.bounds.height < 800 {
            scrollView.alwaysBounceVertical = true
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.equalTo(scrollView)
            make.height.equalTo(610)
        }

        // Draw
        // -----------------------------------------

        contentView.addSubview(balanceLogoImageView)
        balanceLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin).offset(15)
            make.centerX.equalToSuperview()
        }

        contentView.addSubview(balanceNameImageView)
        balanceNameImageView.snp.makeConstraints { make in
            make.top.equalTo(balanceLogoImageView.snp.bottom).offset(20)
            make.centerX.equalTo(balanceLogoImageView)
        }

        contentView.addSubview(wavesImageView)
        wavesImageView.snp.makeConstraints { make in
            make.top.equalTo(balanceNameImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        // TODO: Show people's commitments. Load the data from GitHub and let the faces float by.
        contentView.addSubview(richardImageView)
        richardImageView.snp.makeConstraints { make in
            make.centerX.equalTo(wavesImageView).offset(-40)
            make.centerY.equalTo(wavesImageView).offset(10)
        }

        contentView.addSubview(benImageView)
        benImageView.snp.makeConstraints { make in
            make.centerX.equalTo(wavesImageView).offset(40)
            make.centerY.equalTo(wavesImageView).offset(-10)
        }

        contentView.addSubview(wolffanImageView)
        wolffanImageView.snp.makeConstraints { make in
            make.centerX.equalTo(wavesImageView).offset(110)
            make.centerY.equalTo(wavesImageView).offset(-15)
        }

        contentView.addSubview(jamierumbelowImageView)
        jamierumbelowImageView.snp.makeConstraints { make in
            make.centerX.equalTo(wavesImageView).offset(-110)
            make.centerY.equalTo(wavesImageView).offset(-5)
        }

        contentView.addSubview(joinTitleLabel)
        joinTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(wavesImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        contentView.addSubview(joinSubtitleLabel)
        joinSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(joinTitleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(60)
        }

        mediumButton.addTarget(self, action: #selector(socialButtonAction(_:)), for: .touchUpInside)
        contentView.addSubview(mediumButton)
        mediumButton.snp.makeConstraints { make in
            make.top.equalTo(joinSubtitleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(167)
            make.height.equalTo(47)
        }
        mediumButton.imageView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.centerY.equalToSuperview()
        }

        discordButton.addTarget(self, action: #selector(socialButtonAction(_:)), for: .touchUpInside)
        contentView.addSubview(discordButton)
        discordButton.snp.makeConstraints { make in
            make.top.equalTo(mediumButton)
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.width.equalTo(mediumButton)
            make.height.equalTo(mediumButton)
        }
        discordButton.imageView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }

        twitterButton.addTarget(self, action: #selector(socialButtonAction(_:)), for: .touchUpInside)
        contentView.addSubview(twitterButton)
        twitterButton.snp.makeConstraints { make in
            make.top.equalTo(mediumButton.snp.bottom).offset(10)
            make.centerX.equalTo(mediumButton)
            make.width.equalTo(mediumButton)
            make.height.equalTo(mediumButton)
        }
        twitterButton.imageView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.centerY.equalToSuperview()
        }

        githubButton.addTarget(self, action: #selector(socialButtonAction(_:)), for: .touchUpInside)
        contentView.addSubview(githubButton)
        githubButton.snp.makeConstraints { make in
            make.top.equalTo(twitterButton)
            make.centerX.equalTo(discordButton)
            make.width.equalTo(mediumButton)
            make.height.equalTo(mediumButton)
        }
        githubButton.imageView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 44
        tableView.isScrollEnabled = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "settingsCell")
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(tableView.rowHeight * 3) // 4)
            make.bottom.equalTo(contentView.snp.bottom)
        }

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Button Actions -

    @objc private func socialButtonAction(_ sender: UIButton) {
        var urlString: String?
        switch sender {
        case mediumButton:
            urlString = "https://medium.com/balance-io"
        case discordButton:
            urlString = "https://discord.gg/KR7hDR7"
        case twitterButton:
            urlString = "https://twitter.com/Balance_io"
        case githubButton:
            urlString = "https://github.com/balance-io"
        default:
            break
        }
        if let urlString = urlString, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Table View -

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        cell.isEnabled = false
        cell.sideLabel.text = ""
        let row = indexPath.row + 1
        switch row {
        //        case 0:
        //            cell.imageView?.image = UIImage(named: "notificationsIcon")
        //            cell.textLabel?.text = "Notifications"
        case 1:
            cell.imageView?.image = UIImage(named: "proIcon")
            cell.textLabel?.text = "Balance Pro"
        case 2:
//            cell.isEnabled = true
            cell.imageView?.image = UIImage(named: "currencyIcon")
            cell.textLabel?.text = "Currency"
            cell.sideLabel.text = "USD"
        case 3:
            cell.imageView?.image = UIImage(named: "languageIcon")
            cell.textLabel?.text = "Language"
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Row: \(indexPath.row)")
    }
}
