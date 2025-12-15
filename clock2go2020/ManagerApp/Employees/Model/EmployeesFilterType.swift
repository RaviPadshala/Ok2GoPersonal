//
//  EmployeesFilterType.swift
//  clock2go2020
//
//  Created by Admin on 4/17/20.
//

import UIKit

enum EmployeesFilterType: CaseIterable {
    case byEmployeeCode
    case notActiveOnly
    case activeOnly
    case allEmployees

    var title: String {
        switch self {
            case .byEmployeeCode:
                return "BY_EMP_CODE".localized
            case .notActiveOnly:
                return "NOT_ACTIVE_ONLY".localized
            case .activeOnly:
                return "ACTIVE_ONLY".localized
            case .allEmployees:
                return "ALL_EMP".localized
        }
    }

    static func withTitle(_ title: String) -> EmployeesFilterType? {
        return self.allCases.first { "\($0.title)" == title }
    }

    static func allTitles() -> [String] {
        var titles: [String] = []
        for type in self.allCases {
            titles.append(type.title)
        }
        return titles
    }
}
