//
//  GetMgrEmpReportsObj.swift
//  clock2go2020
//
//  Created by Gleb on 02.12.2020.
//

import Foundation
import UIKit

struct MgrEmpReportsObj: Codable {
    var reports: [String: GetMgrEmpReportsObj]?
}

struct GetMgrEmpReportsObj: Codable, Equatable {
    var dayReports: [MgrEmpReportObj]?

    var date: String?
    var taskName: String?
    var totalHours: Double?
    var reportIdIn: Int?
    var timeIn: String?
    var actionTypeIn: String?
    var remarkIn: String?
    var lonIn: String?
    var latIn: String?
    var locationIn: String?
    var statusIn: Int?
    var standardIn: String?
    var reportIdOut: Int?
    var timeOut: String?
    var actionTypeOut: String?
    var remarkOut: String?
    var lonOut: String?
    var latOut: String?
    var locationOut: String?
    var statusOut: Int?
    var standardOut: String?
    var healthDisclaimerAccepted: Int?
}
