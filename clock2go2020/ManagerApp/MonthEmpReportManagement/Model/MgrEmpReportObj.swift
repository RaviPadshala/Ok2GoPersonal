//
//  MgrEmpReportObj.swift
//  clock2go2020
//
//  Created by Gleb on 02.12.2020.
//

import Foundation
import UIKit

struct MgrEmpReportObj: Codable, Equatable {

    var date: String?
    var taskName: String?
    var totalHours: String?
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

    init(dayReport: GetMgrEmpReportsObj) {
        date = dayReport.date
        taskName = dayReport.taskName
        totalHours = String(format: "%f", dayReport.totalHours ?? 0)
        reportIdIn = dayReport.reportIdIn
        timeIn = dayReport.timeIn
        actionTypeIn = dayReport.actionTypeIn
        remarkIn = dayReport.remarkIn
        lonIn = dayReport.lonIn
        latIn = dayReport.latIn
        locationIn = dayReport.locationIn
        statusIn = dayReport.statusIn
        standardIn = dayReport.standardIn
        reportIdOut = dayReport.reportIdOut
        timeOut = dayReport.timeOut
        actionTypeOut = dayReport.actionTypeOut
        remarkOut = dayReport.remarkOut
        lonOut = dayReport.lonOut
        latOut = dayReport.latOut
        locationOut = dayReport.locationOut
        statusOut = dayReport.statusOut
        standardOut = dayReport.standardOut
    }

}
