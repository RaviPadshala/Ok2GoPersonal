//
//  AccountInfoView.swift
//  clock2go2020
//
//  Created by Admin on 1/3/20.
//

import UIKit

class AccountInfoView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageButton: BadgeButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoStachView: UIStackView!
    @IBOutlet weak var accountImageView: UIView!
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountNameTitle: UILabel!
    @IBOutlet weak var companyNameTitle: UILabel!
    @IBOutlet weak var dateNowLabel: UILabel!
    
    weak var delegate: AccountInfoViewDelegate?
    
   
    
    var viewModel: AccountInfoViewModel?
    private var dateTimer: Timer?
    private var dateWorkItem: DispatchWorkItem?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("AccountInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
    }

    func config(viewModel: AccountInfoViewModel) {
        self.viewModel = viewModel

        accountImage.image = self.viewModel?.getImage()
        accountNameTitle.text = self.viewModel?.getWelcomeNameString()
        companyNameTitle.text = self.viewModel?.getCompanyNameString()
        dateLabel.text = self.viewModel?.getCurrentDateString()

        messageButton.isHidden = !(self.viewModel?.shouldShowMessageButton() ?? false)
        messageButton.badge = self.viewModel?.getNumberOfUnreadNotifications() ?? "0"
        settingsButton.isHidden = !(self.viewModel?.shouldShowSettingButton() ?? false)
        backButton.isHidden = !(self.viewModel?.shouldShowBackButton() ?? false)

        accountImageView.isHidden = !(self.viewModel?.shouldShowAccountImage() ?? false)
        companyNameTitle.isHidden = !(self.viewModel?.shouldShowCompany() ?? false)
        infoStachView.isHidden = !(self.viewModel?.shouldShowInfo() ?? false)
        
        self.setupDateTimer()
    }
    
    func resetCurrentDate() {
        self.dateTimer?.invalidate()
        self.dateTimer = nil
    }
    
    private func setupDateTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let `self` = self else {
                return
            }
            if let time = self.viewModel?.getDateNowString() {
                dateNowLabel.isHidden = false
                dateNowLabel.text = time
                
                let initialTimer = CompaniesDataManager.shared.initialTimerForUpdateUI
                
                if initialTimer > 0 {
                    self.dateWorkItem?.cancel()
                    self.dateWorkItem = DispatchWorkItem(block: { [weak self] in
                        self?.updateCurrentDateInUI()
                        //Start a timer for update time every minute
                        self?.startDateTimer()
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(initialTimer), execute: self.dateWorkItem!)
                }else {
                    self.startDateTimer()
                }
                
            }else {
                dateNowLabel.isHidden = true
            }
        })
    }
    
    private func startDateTimer() {
        self.dateTimer?.invalidate()
        self.dateTimer = nil
        self.dateTimer = Timer.scheduledTimer(withTimeInterval: (1*60), repeats: true) { [weak self] timer in
            self?.updateCurrentDateInUI()
        }
    }
    
    private func updateCurrentDateInUI() {
        if let time = self.viewModel?.getDateNowString() {
            self.dateNowLabel.text = time
        }
    }

    @objc func updateMessageButtonBadge() {
        messageButton.badge = self.viewModel?.getNumberOfUnreadNotifications() ?? "0"
    }

    func setupUI() {
        accountImageView.roundCorners([.allCorners], radius: 25)
        accountImageView.shadow(CGSize(width: 0.3, height: 3), opacity: 0.3, radius: 3, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        accountImageView.border(width: 2.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

        accountImage.roundCorners([.allCorners], radius: 25.0)
    }

    @IBAction func messageButtonAction(_ sender: Any) {
        delegate?.userDidTapMessagesButton()
    }

    @IBAction func settingsButtonAction(_ sender: Any) {
        delegate?.userDidTapSettingsButton()
    }

    @IBAction func backButtonAction(_ sender: Any) {
              _ = NavigationController.shared?.popViewController(animated: true)
        
    }
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        delegate?.userDidTapImageButton()
    }
}

protocol AccountInfoViewDelegate: NSObjectProtocol {
    func userDidTapMessagesButton()
    func userDidTapSettingsButton()
    func userDidTapImageButton()
    
}



