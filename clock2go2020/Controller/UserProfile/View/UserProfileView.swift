//
//  UserProfileView.swift
//  clock2go2020
//
//  Created by Admin on 2/10/20.
//

import UIKit

class UserProfileView: UIView {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var profileSettingsTitle: UILabel!

    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyRoundView: UIView!
    @IBOutlet weak var companyBottomView: UIView!
    @IBOutlet weak var companyTitle: UILabel!
    @IBOutlet weak var companyRoundDetail: UIView!
    @IBOutlet weak var companyNameLabel: UILabel!

    @IBOutlet weak var personalInformationView: UIView!
    @IBOutlet weak var personalInformationRoundView: UIView!
    @IBOutlet weak var personalInformationBottomView: UIView!
    @IBOutlet weak var personalInformationRoundDetail: UIView!
    @IBOutlet weak var personalInformationTitle: UILabel!

    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var reminderRoundView: UIView!
    @IBOutlet weak var reminderBottomView: UIView!
    @IBOutlet weak var reminderRoundDetail: UIView!
    @IBOutlet weak var reminderTitle: UILabel!

    weak var delegate: UserProfileViewDelegate?

    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("UserProfileView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setLocalized()
        setupTap()
        config()
    }

    // MARK: Property
    func setupUI() {
        companyRoundView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        companyRoundView.roundCorners([.allCorners], radius: 9)
        companyBottomView.roundCorners([.bottomRight, .bottomLeft], radius: 15)
        companyRoundDetail.roundCorners([.bottomRight, .bottomLeft], radius: 15)

        personalInformationRoundView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        personalInformationRoundView.roundCorners([.allCorners], radius: 9)
        personalInformationBottomView.roundCorners([.bottomRight, .bottomLeft], radius: 15)
        personalInformationRoundDetail.roundCorners([.bottomRight, .bottomLeft], radius: 15)

        reminderRoundView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        reminderRoundView.roundCorners([.allCorners], radius: 9)
        reminderBottomView.roundCorners([.bottomRight, .bottomLeft], radius: 15)
        reminderRoundDetail.roundCorners([.bottomRight, .bottomLeft], radius: 15)
    }

    func setLocalized() {
        profileSettingsTitle.text = "PROFILE_SETTINGS_TITLE".localized
        companyTitle.text = "COMPANY_NAME_TITLE".localized
        personalInformationTitle.text = "PERSONAL_INFORMATION_TITLE".localized
        reminderTitle.text = "REMINDER_TITLE".localized
    }

    func config() {
        companyNameLabel.text = CompaniesDataManager.shared.getClientName()
    }

    func setupTap() {
        let personalTap = UITapGestureRecognizer(target: self, action: #selector(openPersonalInfoScreen))
        personalInformationView.addGestureRecognizer(personalTap)

        let companyTap = UITapGestureRecognizer(target: self, action: #selector(showChooseCompanyView))
        companyView.addGestureRecognizer(companyTap)

        let reminderTap = UITapGestureRecognizer(target: self, action: #selector(openReminderScreen))
        reminderView.addGestureRecognizer(reminderTap)
    }

    @objc func openPersonalInfoScreen() {
        let vc = ViewSource.personalInfoScreen()
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    @objc func showChooseCompanyView() {
        let vc = ViewSource.chooseListView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        let title = "CHOOSE_COMPANY"
        let data = CompaniesDataManager.shared.getAvailableCompanyNames()

        vc.viewModel = ChooseListViewModel(title: title, data: data)

        vc.choosedType = { index, _ in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CompanyIndexChanged"), object: self, userInfo: nil)
            let companies = CompaniesDataManager.shared.getAvailableCompanies()
            if companies.count > index {
                let selectedCompany = companies[index]
                CompaniesDataManager.shared.setCurrentClientId(selectedCompany.clientId)
            }
            self.config()
            self.delegate?.userDidChangeCompany()
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @objc func openReminderScreen() {
        let vc = ViewSource.reminderDaysScreen()
        NavigationController.shared?.pushViewController(vc, animated: true)
//        let vc = ViewSource.reminderTimeScreen()
//        NavigationController.shared?.pushViewController(vc, animated: true)
    }
}

protocol UserProfileViewDelegate: NSObjectProtocol {
    func userDidChangeCompany()
}
