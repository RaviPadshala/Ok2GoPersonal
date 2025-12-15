//
//  AccountInfoViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import UIKit

enum AccountViewType {

    case allInfo
    case withoutCompany
    case withoutCompanyAndButtons
    case withoutInfo
    case withName

}

class AccountInfoViewModel {

    var type: AccountViewType
    var name: String?
    var companyName: String?
    private var currentDate: Date?

    init(type: AccountViewType) {
        self.type = type

        setNameString()
        setCompanyNameString()
    }

    func getImage() -> UIImage? {
        var image = UIImage(named: "surface1")

        if let imageData = UserDefaultsManager.image {
            image = UIImage(data: imageData)
        }

        return image
    }

    func setNameString() {
        name = CompaniesDataManager.shared.getEmployeeName()

        if let special = CompaniesDataManager.shared.getSpecialClientType(), special == 1 {
            name = "Dear doctor"
        }
    }

    func getNameString() -> String? {
        return name
    }

    func setCompanyNameString() {
        companyName = CompaniesDataManager.shared.getClientName()
    }

    func getCompanyNameString() -> String? {
        return companyName
    }

    func getCurrentDateString(formate: String = "dd.MM.yy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        let date = Date()
        let result = formatter.string(from: date)

        return result
    }

    func getWelcomeString() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
            case 5..<12:
                return "GOOD_MORNING_TITLE".localized + ", "
            case 12..<16:
                return "GOOD_AFTERNOON".localized + ", "
            case 16..<18:
                return "GOOD_AFTERNOON_2".localized + ", "
            case 18..<22:
                return "GOOD_EVENING".localized + ", "
            default:
                return "GOOD_NIGHT".localized + ", "
        }
    }

    func getWelcomeNameString() -> String {
        return getWelcomeString() + (getNameString() ?? "")
    }

    func shouldShowMessageButton() -> Bool {
        switch type {
            case .allInfo:
                return true
            case .withoutCompany, .withoutInfo:
                return false
            case .withoutCompanyAndButtons:
                return false
            case .withName:
                return true
        }
    }

    func shouldShowSettingButton() -> Bool {
        switch type {
            case .allInfo:
                return true
            case .withoutCompany, .withoutInfo:
                return false
            case .withoutCompanyAndButtons:
                return false
            case .withName:
                return true
        }
    }

    func shouldShowBackButton() -> Bool {
        switch type {
            case .allInfo:
                return false
            case .withoutCompany, .withoutInfo:
                return true
            case .withoutCompanyAndButtons:
                return false
            case .withName:
                return false
        }
    }

    func shouldShowCompany() -> Bool {
        switch type {
            case .allInfo:
                return true
            case .withoutCompany, .withoutInfo:
                return false
            case .withoutCompanyAndButtons:
                return false
            case .withName:
                return false
        }
    }

    func shouldShowAccountImage() -> Bool {
        switch type {
            case .allInfo, .withoutCompany:
                return true
            case .withoutInfo:
                return false
            case .withoutCompanyAndButtons:
                return false
            case .withName:
                return false
        }
    }

    func shouldShowInfo() -> Bool {
        switch type {
            case .allInfo, .withoutCompany:
                return true
            case .withoutInfo:
                return false
            case .withoutCompanyAndButtons:
                return true
            case .withName:
                return true
        }
    }

    func getNumberOfUnreadNotifications() -> String {
        let count = PushNotificationManager.sharedInstance.fetch(PushNotification.self, unread: true).count
        return String(describing: count)
    }
    
    func getDateNowString() -> String? {
        if type == .allInfo,
           let date = CompaniesDataManager.shared.getCurrentDate() {
            return date.toString(format: "HH:mm")
        }
        return nil
    }
}
