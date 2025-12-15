//
//  MgrEmpReportListItems.swift
//  clock2go2020
//
//  Created by Gleb on 02.12.2020.
//

import Foundation

class MgrEmpReportListItems: Equatable, NSCopying {

    let day: String?
    let report: GetMgrEmpReportsObj?

    var isExpanded: Bool = false

    var descendants: [MgrEmpReportObj?] = []

    init(day: String?, report: GetMgrEmpReportsObj?, isExpanded: Bool = false) {
        self.day = day
        self.report = report
        self.descendants = report?.dayReports ?? []
        self.isExpanded = isExpanded
    }

    static func == (lhs: MgrEmpReportListItems, rhs: MgrEmpReportListItems) -> Bool {
        return lhs.day == rhs.day
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MgrEmpReportListItems(day: day, report: report, isExpanded: isExpanded)
        return copy
    }
}
