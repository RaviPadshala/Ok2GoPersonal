//
//  MgrDayReports.swift
//  clock2go2020
//
//  Created by Gleb on 29.09.2020.
//

import Foundation
import UIKit
import SwiftyJSON

struct MgrDayReport: Codable, Equatable {

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

    init(dayReports: MgrDayReportsObj) {
        self.date = dayReports.date
        self.empId = dayReports.empId
        self.empName = dayReports.empName
        self.taskName = dayReports.taskName
        self.totalHours = String(format: "%f", dayReports.totalHours ?? 0)
        self.reportIdIn = dayReports.reportIdIn
        self.timeIn = dayReports.timeIn
        self.actionTypeIn = dayReports.actionTypeIn
        self.remarkIn = dayReports.remarkIn
        self.latIn = dayReports.latIn
        self.locationIn = dayReports.locationIn
        self.lonIn = dayReports.lonIn
        self.statusIn = dayReports.statusIn
        self.reportIdOut = dayReports.reportIdOut
        self.timeOut = dayReports.timeOut
        self.actionTypeOut = dayReports.actionTypeOut
        self.remarkOut = dayReports.remarkOut
        self.lonOut = dayReports.lonOut
        self.latOut = dayReports.latOut
        self.locationOut = dayReports.locationOut
        self.statusOut = dayReports.statusOut
    }

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
    }
}
