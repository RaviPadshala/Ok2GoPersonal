//
//  GetMgrReportsObj.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import UIKit
import SwiftyJSON

class MgrDayReportsObj: Codable, Equatable {
    static func == (lhs: MgrDayReportsObj, rhs: MgrDayReportsObj) -> Bool {
        return true
    }

    var dayReports: [MgrDayReport] = []

    var date: String?
    var empId: Int?
    var empName: String?
    var taskName: String?
    var totalHours: String?
    var reportIdIn: Int?
    var timeIn: String?
    var actionTypeIn: String?
    var remarkIn: String?
    var latIn: String?
    var locationIn: String?
    var lonIn: String?
    var statusIn: Int?
    var reportIdOut: Int?
    var timeOut: String?
    var actionTypeOut: String?
    var remarkOut: String?
    var lonOut: String?
    var latOut: String?
    var locationOut: String?
    var statusOut: Int?

    init(rest: [AnyHashable: Any]) {
        let djson = JSON(rest)

        date = djson["date"].stringValue
        empId = djson["empId"].intValue
        empName = djson["empName"].stringValue
        taskName = djson["taskName"].stringValue
        totalHours = djson["totalHours"].stringValue
        reportIdIn = djson["reportIdIn"].intValue
        timeIn = djson["timeIn"].stringValue
        actionTypeIn = djson["actionTypeIn"].stringValue
        remarkIn = djson["remarkIn"].stringValue
        latIn = djson["latIn"].stringValue
        locationIn = djson["locationIn"].stringValue
        lonIn = djson["lonIn"].stringValue
        statusIn = djson["statusIn"].intValue
        reportIdOut = djson["reportIdOut"].intValue
        timeOut = djson["timeOut"].stringValue
        actionTypeOut = djson["actionTypeOut"].stringValue
        remarkOut = djson["remarkOut"].stringValue
        lonOut = djson["lonOut"].stringValue
        latOut = djson["latOut"].stringValue
        locationOut = djson["locationOut"].stringValue
        statusOut = djson["statusOut"].intValue

        if  let reports = djson["dayReports"].array {
            for report in reports {

                guard let rest = report.dictionaryObject else { continue}
                let dayReport = MgrDayReport(rest: rest)
                self.dayReports.append(dayReport)

            }
        }
    }
}
