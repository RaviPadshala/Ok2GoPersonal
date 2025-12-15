//
//  EmployeeDataObj.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation

struct EmployeeObj: Codable {
    var empId: String?
    var empCode: String?
    var empName: String?
    var empPhone: String?
    var empEmail: String?
    var reportWay: Int?
    var active: String?
    var deptIds: [String?]?
    var employerEmail: String?
}
