import UIKit

// MARK: Section
enum SideBarSection: Int, CaseIterable {
    case Action
    case Settings

    var titleSection: String {
        switch self {
            case .Action:
                return  "ACTIONS".localized
            case .Settings:
                return  "SETTINGS".localized
        }
    }
}

enum ActionRow: Int, CaseIterable {
    case regularApp
    case managerApp
    case myProfile
    case myReports
//    case myForms
//    case myTrips
    case myMessages
    case weeklySchedule
    case forms
    case createCard
    

    var title: String {
        switch self {
        case .regularApp:
            return "PERSONAL_APP".localized
        case .managerApp:
            return "MANAGER_APP".localized
        case .myProfile:
            return "MY_PROFILE".localized
        case .myReports:
            return  "MY_REPORTS".localized
            //            case .myForms:
            //                return  "MY_FORMS".localized
            //            case .myTrips:
            //                return  "MY_TRIPS".localized
        case .myMessages:
            return "MESSAGES".localized
        case .weeklySchedule:
            return "WORK_SCHEDULE_SIDE_BAR_TITLE".localized
        case .forms:
            return "Forms".localized
        case .createCard:
            return "Create a card in Wallet".localized
        }
    }

    var icon: UIImage? {
        switch self {
        case .regularApp:
            return nil
        case .managerApp:
            return nil
        case .myProfile:
            return UIImage(named: "1_surface2")
        case .myReports:
            return UIImage(named: "2_reporting")
            //            case .myForms:
            //                return UIImage(named: "3_archive")
            //            case .myTrips:
            //                return UIImage(named: "4_pin")
        case .myMessages:
            return UIImage(named: "5_msg")
        case .weeklySchedule:
            return UIImage(named: "1_surface2")
        case .forms:
            return UIImage(systemName: "arrow.up.doc")?.withTintColor(#colorLiteral(red: 0.1238274649, green: 0.3782030344, blue: 0.6281121969, alpha: 1), renderingMode: .alwaysOriginal)
        case .createCard:
            return UIImage(named: "nfccard")
        
            
        }
    }

    var textColor: UIColor {
        switch self {
            default:
                return #colorLiteral(red: 0.1115099564, green: 0.3005114794, blue: 0.4344237447, alpha: 1)
        }
    }

    var vc: UIViewController? {
        switch self {
        case .regularApp:
            return ViewSource.dashboardScreen()
        case .managerApp:
            if UserDefaultsManager.userLoggedInManager == true {
                return ViewSource.managerScreen()
            } else {
                return ViewSource.setPasswordManagerScreen()
            }
        case .myProfile:
            return ViewSource.userProfileScreen()
        case .myReports:
            if UserDefaultsManager.isManagerApp == true {
                return ViewSource.employeesReportManagementScreen()
            } else {
                return ViewSource.reportManagementScreen()
            }
            //            case .myForms:
            //                return nil//ViewSource.trackingReportManagementScreen()
            //            case .myTrips:
            //                return nil
        case .myMessages:
            return ViewSource.notificationScreen()
        case .weeklySchedule:
            return ViewSource.weeklyScheduleScreen()
        case .forms:
            return ViewSource.formviewScreen()
        case .createCard:
            return ViewSource.createCardView()
        }
    }

    var isEnabled: Bool {
        switch self {
        case .regularApp:
            return true
        case .managerApp:
            return true
        case .myProfile:
            return true
        case .myReports:
            return CompaniesDataManager.shared.hasReportFeature()
            //            case .myForms:
            //                return nil//ViewSource.trackingReportManagementScreen()
            //            case .myTrips:
            //                return nil
        case .myMessages:
            return true
        case .weeklySchedule:
            return true
        case .forms:
            return true
        case .createCard:
            return CompaniesDataManager.shared.hasNFCReportsFeature()
        }
    }

    var additionalView: UIView? {
        switch self {
            case .myMessages:
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
                view.backgroundColor = UIColor.red
                view.roundCorners([.allCorners], radius: 11)
                let label = UILabel()
                label.frame = view.frame
                label.textColor = UIColor.white
                label.textAlignment = .center
                let count = PushNotificationManager.sharedInstance.fetch(PushNotification.self, unread: true).count
                label.text = String(describing: count)
                view.addSubview(label)
                label.center = view.center
                return count > 0 ? view : nil
            default:
                return nil
        }
    }
}

enum SettingRow: Int, CaseIterable {
    case chooseLanguage
    case letgalInformation
    case about
    case support
    case logout

    var title: String {
        switch self {
            case .chooseLanguage:
                return "CHOOSE_LANGUAGE".localized
            case .letgalInformation:
                return "LEGAL_INFORMATION".localized
            case .about:
                return "ABOUT".localized
            case .support:
                return "SUPPORT".localized
            case .logout:
                return "signOut".localized
        }
    }
    var icon: UIImage? {
        switch self {
            case .chooseLanguage:
                return UIImage(named: "6_earth")
            case .letgalInformation:
                return UIImage(named: "8_document")
            case .about:
                return UIImage(named: "9_roundInformationButton")
            case .support:
                return UIImage(named: "10_telephone")
            case .logout:
                return UIImage(named: "logoutIcon")
        }
    }

    var textColor: UIColor {
        switch self {
            default:
                return #colorLiteral(red: 0.1115099564, green: 0.3005114794, blue: 0.4344237447, alpha: 1)
        }
    }

    var additionalView: UIView? {
        switch self {
            case .chooseLanguage:
                if let langString = UserDefaultsManager.appleLanguagesNew.first,
                    let lang = LanguageEntity.withIdentifier(langString) {
                    let image = UIImageView(image: lang.languageImage)
                    image.contentMode = .scaleAspectFit
                    return image
                } else {
                    return nil
                }
            case .letgalInformation:
                return nil
            case .about:
                return nil
            case .support:
                return nil
            case .logout:
                return nil
        }
    }

    var vc: UIViewController? {
        switch self {
            case .chooseLanguage:
                let vc = ViewSource.languageListScreen()
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                return vc
            case .letgalInformation:
                return ViewSource.legalInformationScreen()
            case .about:
                return ViewSource.aboutUsScreen()
            case .support:
                return ViewSource.supportScreen()
            case .logout:
                return nil
        }
    }

    var isEnabled: Bool {
        return true
    }
}
