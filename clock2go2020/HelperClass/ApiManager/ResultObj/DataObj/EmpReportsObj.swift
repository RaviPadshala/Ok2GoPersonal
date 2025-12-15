//
//  EmpReportsObj.swift
//  clock2go2020
//
//  Created by Admin on 3/10/20.
//

import UIKit

struct EmpReportsObj: Codable {
    var isClosed: Bool?
    var reports: [String: EmpDayReportsObj]?
}

struct EmpDayReportsObj: Codable {
    var dayReports: [EmpReportObj]?

    var date: String?
    var taskName: String?
    var taskID: String?
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
    var trnsType: Int?
    var extraFields: [String: Int]?
    var eventType: String?
    var eventName: String?
}
