//
//  GetMonthStatusObj.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/9/20.
//

import Foundation
import SwiftyJSON

struct GetMonthSummaryObj: Codable, Equatable {

    var empId: Int?
    var empCode: String?
    var empName: String?
    var totalWorkDays: Int?
    var totalInOutTransactions: Int?
    var totalMissingReports: Int?
    var totalAbsenseReports: Int?
    var totalTimeDecimal: String?
    var monthClosed: Int?
    var monthApproved: Int?
    var employerName: String?
    var employerApprovalDate: String?
    var employerApproval: Int?
    var closedDate: String?
    var employerEmail: String?
}
