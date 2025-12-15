//
//  EmployeesReportManagementViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 16.09.2020.
//

import Foundation
import UIKit
import AnyCodable

class EmployeesReportManagementViewModel {

    // MARK: - Private var
    private var reportListItems: [MgrReportListItems] = []
    private var monthObj: MonthObj?
    private var days: [String]? = []

    private var filterType: SortingBy = .allReports
    private var isFilterActivated: Bool = false
    private var filteredListItems: [MgrReportListItems] = []
    private var filteredDays: [String]? = []

    private var selectedEmployees: [Any] = []

    // MARK: - Public var
    var month: String = ""
    var currentDay: String = ""
    let loadingView = LoadingView()

    // MARK: - Delegate
    weak var delegate: EmployeesReportManagemenViewModelDelegate?

    // MARK: - Init Employees Report
    init(date: Date = Date()) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")

        if UserDefaultsManager.dateMgrReport != Date() {
            self.month = date.toString(format: "yyyy-MM")
            self.currentDay = date.toString(format: "yyyy-MM-dd")
        } else {
            self.month = UserDefaultsManager.dateMgrReport.toString(format: "yyyy-MM")
            self.currentDay = UserDefaultsManager.dateMgrReport.toString(format: "yyyy-MM-dd")
        }

    }

    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    // MARK: Public func
    // Api call GetMgrReportsEndpoint
    func loadData() {
        vc?.view.addSubview(loadingView)

        let getEmpReports = GetMgrReportsEndpoint(month: month)
        getEmpReports.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                print("Get Manager  Employee Reports: success")
                self.setReports(allReports: result?.data ?? [:])
                self.delegate?.didLoadData()
            } else {
                NavigationController.shared?.showErrorView(error: error)
                print("Get Manager Employee Reports: failed")
            }
        }
    }

    // Set Emp reports
    func setReports(allReports: [String: AnyCodable]) {

        let oneDayEmployeesReports = allReports.first(where: { $0.key == currentDay })?.value.value // Any

        guard let employeesReports = oneDayEmployeesReports as? [String: Any] else {return}

        reportListItems = []

        for employeeReports in employeesReports {
            guard let rest = employeeReports.value as? [String: Any] else { continue}

            let reports = MgrDayReportsObj(rest: rest)

            reportListItems.append(MgrReportListItems(day: reports.date, report: reports))

            let daysArray = Array(allReports.keys)
            self.days = daysArray.sorted()
        }

        delegate?.didLoadData()
    }

    // MARK: - Table View Delegate
    func getNumberOfSections() -> Int {
        return  isFilterActivated ? filteredListItems.count : reportListItems.count
    }

    func getNumberOfRows(section: Int) -> Int {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems

        if reportsArray.indices.contains(section) {
            let item = reportsArray[section]

            // Check if menu has descendant submenus and if it's expanded.
            if item.descendants.count > 0 && item.isExpanded {
                // Return number of descendant submenus + root menu item.
                return item.descendants.count + 1
            } else {
                // Return only root menu item.
                return 1
            }
        } else {
            return 0
        }
    }

    func getNumberOfExpandedRows() -> Int {
        let reportsArray =  isFilterActivated ? filteredListItems :reportListItems

        var row = reportsArray.count

        for reportItem in reportsArray {
            if reportItem.isExpanded {
                row += reportItem.descendants.count
            }
        }

        return row
    }

    func getModelForRowAt(section: Int, row: Int) -> EmployeesReportTableViewCellViewModel? {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems

        if reportsArray.indices.contains(section) {

            let isSelected = getSelectionState(by: IndexPath(row: row, section: section))
            let reportItem = reportsArray[section]

            if row == 0 {

                if   let day = reportItem.report?.date,
                     let report = reportItem.report,
                     let date = day.getDateFromStringWithFormat("yyyy-MM-dd") {
                    let totalHours = getCumulativeHours(section: section, row: row)

                    return EmployeesReportTableViewCellViewModel(date: date, report: report, filterType: filterType, month: monthObj, isExpanded: reportItem.isExpanded, totalHours: totalHours, isSelected: isSelected)
                }
            } else {

                if   reportItem.descendants.indices.contains(row - 1),
                     let day = reportItem.report?.date,
                     let date = day.getDateFromStringWithFormat("yyyy-MM-dd") {
                    let totalHours = getCumulativeHours(section: section, row: row)
                    let report = reportItem.descendants[row - 1]

                    return EmployeesReportTableViewCellViewModel(date: date, report: report!, filterType: filterType, totalHours: totalHours, isSelected: isSelected )
                }
            }
        }
        return nil
    }

    func getCumulativeHours(section: Int, row: Int) -> String {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        var cumulativeHours = ""
        let reportItem = reportsArray[section]
        if reportsArray.indices.contains(section) {
            if row == 0 {
                cumulativeHours = (cumulativeHours + (reportItem.report?.totalHours ?? "00:00")  )

                return cumulativeHours
            } else {
                if   reportItem.descendants.indices.contains(row - 1),
                     let report = reportItem.descendants[row - 1] {
                    cumulativeHours = (cumulativeHours + (report.totalHours ?? "00:00")  )

                    return cumulativeHours
                }
            }
        }
        return "00:00"
    }

    func isItemExpandable(section: Int, row: Int) -> Bool {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let reportItem = reportsArray[section]
        if row == 0 {
            return reportItem.descendants.count  > 1
        }

        return false
    }

    func toggleItem(section: Int, row: Int) {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems

        let reportItem = reportsArray[section]
        if isItemExpandable(section: section, row: row) {
            reportItem.isExpanded = !(reportItem.isExpanded )
        }
    }

    // MARK: Filtered

    func filterList(reportFilterType: SortingBy) {
        filterType = reportFilterType
        isFilterActivated = true
        filteredListItems = []

        switch reportFilterType {
        case .missings:
            filteredListItems = getMissings()
        case .absences:
            filteredListItems = getAbsences()
        case .breaks:
            filteredListItems = getBreaks()
        case .noReport:
            filteredListItems = getNoReports()
        case .standards:
            isFilterActivated = false
        case .allReports:
            isFilterActivated = false
        }
    }

    func getMissings() -> [MgrReportListItems] {
        var missings: [MgrReportListItems] = []
        var days: [String] = []

        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? MgrReportListItems else { return [] }
            if let report = reportItem.report {
                if AbsenceTypeEntity.withIdentifier(Int(report.actionTypeIn ?? "0")!) == nil {
                    if let timeIn = report.timeIn, timeIn.count > 0 {
                        if let timeOut = report.timeOut, timeOut.count > 0{
                            print("timeout", timeOut)
                        }else{
                            print("report.actionTypeIn",report.actionTypeIn ?? "actiontype")
                            missings.append(reportItem)
                            if let day = reportItem.day {
                                days.append(day)
                            }
                        }
                    }else{
                        if let timeOut = report.timeOut, timeOut.count > 0 {
                            print("report.actionTypeIn",report.actionTypeIn ?? "actiontype")
                            missings.append(reportItem)
                            if let day = reportItem.day {
                                days.append(day)
                            }
                        }
                    }
                }
            }
        }
        filteredDays = days.sorted()
        return missings
    }
    
    func getNoReports() -> [MgrReportListItems] {
        var missings: [MgrReportListItems] = []
        var days: [String] = []

        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? MgrReportListItems else { return [] }
            if reportItem.report?.timeIn == nil && reportItem.report?.timeOut == nil {
                missings.append(reportItem)
                if let day = reportItem.day {
                    days.append(day)
                }
            }
        }
        filteredDays = days.sorted()
        return missings
    }
    
    func getAbsences() -> [MgrReportListItems] {
        var absences: [MgrReportListItems] = []
        var days: [String] = []

        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? MgrReportListItems else { return [] }
            if let action = reportItem.report?.actionTypeIn, let actionID = Int(action), AbsenceTypeEntity.withIdentifier(actionID) != nil {
                absences.append(reportItem)
                if let day = reportItem.day {
                    days.append(day)
                }
            }
        }

        filteredDays = days.sorted()
        return absences
    }

    func getBreaks() -> [MgrReportListItems] {
        var breaks: [MgrReportListItems] = []
        var days: [String] = []

        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? MgrReportListItems else { return [] }
            if reportItem.report?.actionTypeIn == "99" || reportItem.report?.actionTypeIn == "98" || reportItem.report?.actionTypeOut == "99" || reportItem.report?.actionTypeOut == "98" {

                let reports = reportItem.descendants.filter({($0?.actionTypeIn == "99" || $0?.actionTypeIn == "98" || $0?.actionTypeOut == "99" || $0?.actionTypeOut == "98" )})
                if reports.count > 1 {
                    reportItem.descendants = reports
                }

                breaks.append(reportItem)

                if let day = reportItem.day {
                    days.append(day)
                }
            } else {
                let reports = reportItem.descendants.filter({($0?.actionTypeIn == "99" || $0?.actionTypeIn == "98" || $0?.actionTypeOut == "99" || $0?.actionTypeOut == "98" )})
                if reports.count > 1 {
                    reportItem.descendants = reports
                    reportItem.isExpanded = true
                    breaks.append(reportItem)

                    if let day = reportItem.day {
                        days.append(day)
                    }
                }
            }
        }

        filteredDays = days.sorted()
        return breaks
    }

    func unfilterList() {
        isFilterActivated = false
        filteredListItems = []
        filteredDays = []
    }

    func getModelForActionView() -> ReportActionViewModel {
        let hasMissingReports = getMissings().count > 0
        return ReportActionViewModel(type: filterType, month: month, hasMissingReports: hasMissingReports)
    }

    // Selected employees
    func getItem(by index: IndexPath) -> Reports? {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems

        if reportsArray.indices.contains(index.section) {
            if index.row == 0 {
                let item = reportsArray[index.section]
                return .reports(item)
            } else {
                if  reportsArray[index.section].descendants.indices.contains(index.row - 1) {
                    if let item = reportsArray[index.section].descendants[index.row - 1] {
                        return .dayReports(item)
                    }
                }
            }
        }
        return nil
    }

    func selectEmployee(by indexPath: IndexPath) {

        if indexPath.row == 0 {
            selectSection(by: indexPath)
            return
        }

        guard let item = getItem(by: indexPath) else {
            return
        }

        switch item {
        case .reports(_):
            break
        case .dayReports(let dayReports):
            if selectedEmployees.contains(obj: dayReports) {
                selectedEmployees.removeObject(object: dayReports)
                print(selectedEmployees.count)
            } else {
                selectedEmployees.append(dayReports)
                print(selectedEmployees.count)
            }
            break
        }
    }

    func getSelectionSectionState(by index: IndexPath) -> Bool {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems

        let reports = reportsArray[index.section]

        for item in reports.descendants {
            if !selectedEmployees.contains(obj: item) {
                return false
            }
        }
        return true
    }

    func selectSection(by indexPath: IndexPath) {
        let isSelected = getSelectionSectionState(by: indexPath)

        let reportsArray = isFilterActivated ? filteredListItems : reportListItems

        let reports = reportsArray[indexPath.section]

        if indexPath.row == 0 {

            for item in reports.descendants {

                if isSelected {
                    if selectedEmployees.contains(obj: item) {
                        selectedEmployees.removeObject(object: item)
                        print(selectedEmployees.count)
                    }
                } else {
                    if !selectedEmployees.contains(obj: item) {
                        selectedEmployees.append(item as Any)
                        print(selectedEmployees.count)
                    }
                }
            }
        }
    }

    func getSelectionState(by index: IndexPath) -> Bool {

        if index.row == 0 {
            return getSelectionSectionState(by: index)
        }
        guard let item = getItem(by: index) else {
            return false
        }

        var state: Bool = false
        switch item {
        case .reports(_):
            break
        case .dayReports(let dayReports):
            state = selectedEmployees.contains(obj: dayReports)
            break
        }
        return state
    }

    func getSelectionAllState() -> Bool {

        for report in reportListItems {

            for item in report.descendants {

                if !selectedEmployees.contains(obj: item) {
                    return false
                }
            }
        }
        return true
    }

    func getSelectAllButtonImage() -> UIImage? {
        let isAllSelected = getSelectionAllState()
        return isAllSelected ? UIImage(named: "checked_terms") : UIImage(named: "unchecked_terms")
    }

    func selectAll() {
        let isAllSelected = getSelectionAllState()
        for report in reportListItems {
            for item in report.descendants {
                if isAllSelected {
                    if selectedEmployees.contains(obj: item) {
                        selectedEmployees.removeObject(object: item)
                        print(selectedEmployees.count)
                    }
                } else {
                    if !selectedEmployees.contains(obj: item) {
                        selectedEmployees.append(item as Any)
                        print(selectedEmployees.count)
                    }
                }
            }
        }
    }

    func setNewStatusReport(empId: String, reportId: Int, remark: String ) {
        // Set status for update report
          vc?.view.addSubview(loadingView)

        let setStatusReport = SetReportStatus(empId: empId, reportId: reportId, status: 4, remark: remark)
        setStatusReport.apiCall { (error) in
                 self.loadingView.removeFromSuperview()

            if  (error?.success ?? false) == false {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

    func getItemReports() {
        guard let employeesReports = selectedEmployees as? [MgrDayReport] else {return}

        for items in employeesReports {

                if let empId = items.empId,
                   let reportIdIn = items.reportIdIn,
                   reportIdIn != 0,
                   let status = items.statusIn,
                   status != 4,
                   let remark = items.remarkIn {
                    self.setNewStatusReport(empId: String(empId), reportId: reportIdIn, remark: remark)
                }

                if let empId = items.empId,
                   let reportIdOut = items.reportIdOut,
                   reportIdOut != 0,
                   let status = items.statusOut,
                   status != 4,
                   let remark = items.remarkOut {
                    self.setNewStatusReport(empId: String(empId), reportId: reportIdOut, remark: remark)
            }
        }
    }

    func shouldSHowApproveButton() -> Bool {
        if selectedEmployees.count > 0 {
            return false
        }
        return true
    }
}

// MARK: - Protocol
protocol EmployeesReportManagemenViewModelDelegate: NSObjectProtocol {
    func didLoadData()
}

enum Reports {

    case reports(MgrReportListItems)
    case dayReports(MgrDayReport)
}
