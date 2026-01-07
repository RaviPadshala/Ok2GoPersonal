//
//  ReportWaytype.swift
//  clock2go2020
//
//  Created by Admin on 4/14/20.
//

import Foundation

enum ReportWayType: Int, CaseIterable {
    case loginAndLogout             = 2
    case withEmployeeCode           = 3
    case withTask                   = 4
    case withEmployeeCodeAndTask    = 1
    case teamManagerAndTask         = 5
    case exitAndReturnFromService   = 6

    static func withTitle(_ title: String) -> ReportWayType? {
        return self.allCases.first { $0.title == title }
    }

    var title: String {
        switch self {
            case .loginAndLogout:
                return "LOGIN_AND_LOGOUT".localized
            case .withEmployeeCode:
                return "WITH_EMPLOYEE_CODE".localized
            case .withTask:
                return "WITH_TASK".localized
            case .withEmployeeCodeAndTask:
                return "WITH_EMPLOYEE_CODE_AND_TASK".localized
            case .teamManagerAndTask:
                return "TEAM_MANAGER_AND_TASK".localized
        case .exitAndReturnFromService:
            return "EXIT_AND_RETURN_FROM_SERVICE".localized
        }
    }

    static func allReportTypes() -> [String] {
        var types: [String] = []

        for type in ReportWayType.allCases {
            types.append(type.title)
        }

        return types
    }
}
