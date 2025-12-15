//
//  DepartmentObj.swift
//  clock2go2020
//
//  Created by Admin on 5/12/20.
//

import UIKit

struct DepartmentObj: Codable {
    var departmentId: Int?
    var departmentName: String?
    var employees: [EmployeeByDepartmentObj]?
}

struct EmployeeByDepartmentObj: Codable, Equatable {
    var empId: Int?
    var empName: String?

    static func == (lhs: EmployeeByDepartmentObj, rhs: EmployeeByDepartmentObj) -> Bool {
        return lhs.empId == rhs.empId
    }
}
