//
//  NotificationTypeEntity.swift
//  clock2go2020
//
//  Created by Admin on 3/18/20.
//

import UIKit

enum NotificationTypeEntity: String {

    case ENTRY_ALERT
    case EXIT_ALERT
    case ABSENCE_ALERT
    case ENTRY_REMINDER
    case EXIT_REMINDER
    case PERSONAL_REMINDER
    case MISSES_ALERT_EMP
    case MISSES_ALERT_MANAGER
    case PRESENCE_REPORT
    case STANDARD_HOURS_ALERT
    case ADDITIONAL_HOURS_ALERT
    case POLYGON_ENTRY_ALERT
    case POLYGON_EXIT_ALERT
    case THREE_DAYS_ALERT
    case TWELVE_HOURS_ALERT
    case SEVEN_DAYS_ALERT
    case FIFTEEN_HOURS_ALERT
    case FOUR_SATURDAYS_ALERT
    case INITIATED_MESSAGE
    case REPORTS_ISSUE
    case SYSTEM_ISSUE
    case SERVICE_MESSAGE

    func hasAction() -> Bool {
        switch self {
            case .PRESENCE_REPORT, .POLYGON_ENTRY_ALERT, .POLYGON_EXIT_ALERT, .INITIATED_MESSAGE, .REPORTS_ISSUE, .SYSTEM_ISSUE, .SERVICE_MESSAGE:
                return false
            default:
                return true
        }
    }

    func shouldLogin() -> Bool {
        switch self {
            case .ENTRY_ALERT, .ENTRY_REMINDER:
                return true
            default:
                return false
        }
    }

    func shouldLogout() -> Bool {
        switch self {
            case .EXIT_ALERT, .EXIT_REMINDER:
                return true
            default:
                return false
        }
    }

    func shouldAbsence() -> Bool {
         switch self {
            case .ABSENCE_ALERT:
                return true
            default:
                return false
        }
    }

    func shouldOpenReports() -> Bool {
        switch self {
        case .MISSES_ALERT_EMP, .MISSES_ALERT_MANAGER, .STANDARD_HOURS_ALERT:
                return true
            default:
                return false
        }
    }

}
