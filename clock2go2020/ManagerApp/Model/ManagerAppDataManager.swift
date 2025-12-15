//
//  ManagerAppDataManager.swift
//  clock2go2020
//
//  Created by Admin on 4/17/20.
//

import UIKit

class ManagerAppDataManager {

    static let shared = ManagerAppDataManager()

    private var managerToken: String?

    var departments: [DepartmentsObj?] = []

    // token
    func setManagerToken(token: String?) {
        managerToken = token
    }

    func getManagerToken() -> String? {
        return managerToken
    }

    // departments
    func setDepartments(departments: [DepartmentsObj?]) {
        self.departments = departments
    }

    func getDepartments() -> [DepartmentsObj?] {
        return self.departments
    }

    func getDepartmentTitles() -> [String] {
        var titles: [String] = []

        for department in departments {
            titles.append(department?.empGrpName ?? "")
        }

        return titles
    }

    //

}
