//
//  ReportListItem.swift
//  clock2go2020
//
//  Created by Admin on 3/20/20.
//

import UIKit

class ReportListItem: Equatable, NSCopying {

    let day: String?
    let report: EmpDayReportsObj?

    var isExpanded: Bool = false

    var descendants: [EmpReportObj] = []

    init(day: String?, report: EmpDayReportsObj?, isExpanded: Bool = false) {
        self.day = day
        self.report = report
        self.descendants = report?.dayReports ?? []
        self.isExpanded = isExpanded
    }

    static func == (lhs: ReportListItem, rhs: ReportListItem) -> Bool {
        return lhs.day == rhs.day
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ReportListItem(day: day, report: report, isExpanded: isExpanded)
        return copy
    }
}
