//
//  ManagerMenuCellModel.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/9/20.
//

import UIKit

enum ManagerMenu: Int, CaseIterable {
//    case executiveCertifications = 0
//    case workAreas = 1
    case employees = 0
    case working
    case myReports = 2
//    case absences = 5

    var title: String {
        switch self {
//            case .executiveCertifications:
//                return "אישורי מנהלים"
//            case .workAreas:
//                return "אזורי עבודה"
            case .employees:
                return "EMPLOYEES".localized
            case .working:
                return  ""
            case .myReports:
                return "MY_REPORTS".localized
//            case .absences:
//                return "העדרויות"
        }
    }

    var icon: UIImage? {
        switch self {
//            case .executiveCertifications:
//                return UIImage(named: "contract6")
//            case .workAreas:
//                return  UIImage(named: "pin")
            case .employees:
                return UIImage(named: "employees")
            case .working:
                return UIImage(named: "circle1")
            case .myReports:
                return UIImage(named: "reporting")
//            case .absences:
//                return UIImage(named: "stickman")
        }
    }

    var view: UIView? {
        switch self {
//            case .executiveCertifications:
//                return nil
//            case .workAreas:
//                return nil
            case .employees:
                return EmployeesView()
            case .working:
                return DailyStatusView()
                case .myReports:
                return nil
//            case .absences:
//                return nil
        }
    }
}
