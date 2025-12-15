//
//  MgrReportListItems.swift
//  clock2go2020
//
//  Created by Gleb on 29.09.2020.
//

import Foundation
import UIKit

class MgrReportListItems: Equatable, NSCopying {

    let day: String?
    let report: MgrDayReportsObj?

    var isExpanded: Bool = false

    var descendants: [MgrDayReport?] = []

    init(day: String?, report: MgrDayReportsObj?, isExpanded: Bool = false) {
        self.day = day
        self.report = report
        self.descendants = report?.dayReports ?? []
        self.isExpanded = isExpanded
    }

    static func == (lhs: MgrReportListItems, rhs: MgrReportListItems) -> Bool {
        return lhs.day == rhs.day
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MgrReportListItems(day: day, report: report, isExpanded: isExpanded)
        return copy
    }

}
