//
//  MothEmpReportsViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 02.12.2020.
//

import Foundation
import UIKit

class MothEmpReportsViewModel {

    private var reportListItems: [MgrEmpReportListItems] = []

    private var filterType: SortingBy = .allReports
    private var isFilterActivated: Bool = false
    private var filteredListItems: [MgrEmpReportListItems] = []
    private var filteredDays: [String]? = []
    private var selectedEmployees: [Any] = []

    private var days: [String]? = []
    private var monthObj: MonthObj?

    var isWaitingUpdateLoginResponse = false
    var isWaitingUpdateLogoutResponse = false

    weak var delegate: MonthEmpReportsViewModelDelegate?
    var month: String
    var monthTitle: String = ""
    let loadingView = LoadingView()
    var monthIndex: Int = 0

    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    init(date: Date = Date()) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")

        if UserDefaultsManager.dateMgrReport != Date() {
            self.month = UserDefaultsManager.dateMgrReport.toString(format: "yyyy-MM")
             monthIndex = calendar.component(.month, from: UserDefaultsManager.dateMgrReport)
        } else {
            self.month = date.toString(format: "yyyy-MM")
             monthIndex = calendar.component(.month, from: date)
        }

        if CompaniesDataManager.shared.getSpecialClientType() == 1 {
            monthIndex = monthIndex - 1
            let date = self.getDateForMonthIndex(index: monthIndex)
            UserDefaultsManager.dateMgrReport = date
            self.month = date.toString(format: "yyyy-MM")
        }

        self.monthTitle = calendar.monthSymbols[monthIndex - 1]
        self.monthObj = getMonthObj(monthIndex: monthIndex)
    }

    init(monthIndex: Int) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")

        self.month = ""
        self.monthTitle = calendar.monthSymbols[monthIndex]

        let date = self.getDateForMonthIndex(index: monthIndex + 1)
        UserDefaultsManager.dateMgrReport = date
        self.month = date.toString(format: "yyyy-MM")
        self.monthObj = getMonthObj(monthIndex: monthIndex + 1)
    }

    func getMonthObj(monthIndex: Int) -> MonthObj? {
        if let months = CompaniesDataManager.shared.getMonthStatistics() {
            let monthKeys = Array(months.keys)
            let monthValues = Array(months.values)

            let key = monthKeys.first(where: {Int($0) == monthIndex}) ?? ""
            let keyIndex = monthKeys.firstIndex(of: key) ?? 0

            return monthValues[keyIndex]
        }
        return nil
    }

    func getMonthTitle() -> String {
        return monthTitle
    }

    func getDateForMonthIndex(index: Int) -> Date {
        guard var selectedDate = Calendar.current.date(bySetting: .month, value: index, of: Date()) else { return Date() }

        if Date().months(from: selectedDate) < 0 {
            selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? Date()
        }

        return selectedDate
    }

    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"

        return formatter.date(from: month)
    }

    func loadData(empId: Int) {
        vc?.view.addSubview(loadingView)

        let getEmpReports = GetMgrEmpReportsEnpoint(month: month, empId: empId)
        getEmpReports.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                print("Get Mgr Emp Reports: success")
                self.setReports(reports: result)
                self.delegate?.didLoadData()
            } else {
                NavigationController.shared?.showErrorView(error: error)
                print("Get Mgr Emp Reports: failed")
            }
        }
    }

    func setReportsObj(_ reportsObj: MgrEmpReportsObj?) {
        setReports(reports: reportsObj?.reports)
    }

    func setReports(reports: [String: GetMgrEmpReportsObj]?) {
        unfilterList()

        guard let reportsList = reports else { return }

        reportListItems = []

        for report in reportsList {
            reportListItems.append(MgrEmpReportListItems(day: report.key, report: report.value))
        }

        if reports != nil {
            let daysArray = Array(reports!.keys)

            self.days = daysArray.sorted()
        }
        delegate?.didLoadData()
    }

    func getNumberOfSections() -> Int {
        return isFilterActivated ? filteredListItems.count : reportListItems.count
    }

    func getNumberOfRows(section: Int) -> Int {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let daysArray = isFilterActivated ? filteredDays : days

        if (daysArray?.count ?? 0) > section {
            if let day = daysArray?[section], let reportItem = reportsArray.first(where: { $0.day == day }), reportItem.isExpanded {
                return reportItem.descendants.count  + 1
            } else {
                return 1
            }
        }
        return 0
    }

    func getNumberOfExpandedRows() -> Int {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems

        var row = reportsArray.count

        for reportItem in reportsArray {
            if reportItem.isExpanded {
                row += reportItem.descendants.count
            }
        }

        return row
    }

    func getModelForItemAt(section: Int, row: Int) -> MonthEmpReportTableViewCellModel? {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let daysArray = isFilterActivated ? filteredDays : days

        if reportsArray.indices.contains(section) {
            let isSelected = getSelectionState(by: IndexPath(row: row, section: section))

            if row == 0 {
                if let day = daysArray?[section],
                   let reportItem = reportsArray.first(where: { $0.day == day }),
                   let report = reportItem.report,
                   let date = day.getDateFromStringWithFormat("yyyy-MM-dd") {
                    let hours = getCummulativeTotalHoursFor(section: section)
                    return MonthEmpReportTableViewCellModel(date: date, report: report, month: monthObj, isExpanded: reportItem.isExpanded, filterType: filterType, totalHours: hours, isSelected: isSelected)
                }
            } else {
                if let day = daysArray?[section], let reportItem = reportsArray.first(where: { $0.day == day }), reportItem.descendants.indices.contains(row - 1), let date = day.getDateFromStringWithFormat("yyyy-MM-dd") {
                    if let report = reportItem.descendants[row - 1] {
                        return MonthEmpReportTableViewCellModel(date: date, report: report, filterType: filterType, isSelected: isSelected)
                    }
                }
            }
        }
        return nil
    }

    func getCummulativeTotalHoursFor(section: Int) -> Double {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let daysArray = isFilterActivated ? filteredDays : days

        var cumulativeHours = 0.0

        if reportsArray.indices.contains(section) {

            for index in 0...section {
                if let day = daysArray?[index], let reportItem = reportsArray.first(where: { $0.day == day }) {
                    cumulativeHours = cumulativeHours + (reportItem.report?.totalHours ?? 0.0)
                }

            }
        }

        return cumulativeHours
    }

    func isItemExpandable(section: Int, row: Int) -> Bool {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let daysArray = isFilterActivated ? filteredDays : days

        if row == 0, let day = daysArray?[section], let reportItem = reportsArray.first(where: { $0.day == day }) {
            return reportItem.descendants.count > 1
        }

        return false
    }

    func toggleItem(section: Int, row: Int) {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let daysArray = isFilterActivated ? filteredDays : days

        if isItemExpandable(section: section, row: row), let day = daysArray?[section], let reportItem = reportsArray.first(where: { $0.day == day }) {
            reportItem.isExpanded = !reportItem.isExpanded
        }
    }

    func getTaskIdByName(_ name: String?) -> String? {
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        if let task = tasks.first(where: {$0?.taskName == name}) {
            return task?.taskId
        }
        return nil
    }

    func getDateFrom(dateString: String?, timeString: String?) -> String? {
        guard let date = dateString, let time = timeString else { return nil }

        let fullString = date + " " + time

        let newDateString = fullString.changeDateFormat(from: "dd/MM/yyyy HH:mm a", to: "yyyy-MM-dd HH:mm:ss")

        if newDateString == "" {
            return fullString.changeDateFormat(from: "dd/MM/yyyy HH:mm", to: "yyyy-MM-dd HH:mm:ss")
        }

        return newDateString

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

    func getMissings() -> [MgrEmpReportListItems] {
        var missings: [MgrEmpReportListItems] = []
        var days: [String] = []

        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? MgrEmpReportListItems else { return [] }
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
    
    func getNoReports() -> [MgrEmpReportListItems] {
        var missings: [MgrEmpReportListItems] = []
        var days: [String] = []

        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? MgrEmpReportListItems else { return [] }
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

    func getAbsences() -> [MgrEmpReportListItems] {
        var absences: [MgrEmpReportListItems] = []
        var days: [String] = []

        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? MgrEmpReportListItems else { return [] }
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

    func getBreaks() -> [MgrEmpReportListItems] {
        var breaks: [MgrEmpReportListItems] = []
        var days: [String] = []

        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? MgrEmpReportListItems else { return [] }
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

    func getItem(by index: IndexPath) -> EmpReports? {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let daysArray = isFilterActivated ? filteredDays : days

        if reportsArray.indices.contains(index.section) {

            if index.row == 0 {
                if let day = daysArray?[index.section],
                   let report = reportsArray.first(where: { $0.day == day }) {
                    return .reports(report)
                }
            } else {
                if let day = daysArray?[index.section],
                   let reportItem = reportsArray.first(where: { $0.day == day }),
                   reportItem.descendants.indices.contains(index.row - 1) {
                    if let report = reportItem.descendants[index.row - 1] {
                        return .dayReports(report)
                    }
                }
            }
        }
        return nil
    }

    func selectEmployee(by indexPath: IndexPath) {

        if indexPath.row == 0 {
            getSection(by: indexPath)
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

    func getSelectionState(by index: IndexPath) -> Bool {

        if index.row == 0 {
            return getSectionState(by: index)
        }
        guard let item = getItem(by: index) else {
            return false
        }

        switch item {
        case .reports(_):
            break
        case .dayReports(let dayReports):
            return selectedEmployees.contains(obj: dayReports)
        }
        return false
    }

    func getSectionState(by index: IndexPath) -> Bool {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let daysArray = isFilterActivated ? filteredDays : days

        if let day = daysArray?[index.section],
           let report =  reportsArray.first(where: { $0.day == day }) {
            for item in report.descendants {
                if !selectedEmployees.contains(obj: item) {
                    return false
                }
            }
        }
        return true
    }

    func getSection(by indexPath: IndexPath) {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let daysArray = isFilterActivated ? filteredDays : days

        let isSelected = getSectionState(by: indexPath)

        if let day = daysArray?[indexPath.section],
           let report =  reportsArray.first(where: { $0.day == day }) {
            for item in report.descendants {

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
        vc?.view.addSubview(loadingView)

        let setStatusReport = SetReportStatus(empId: empId, reportId: reportId, status: 4, remark: remark)
        setStatusReport.apiCall { (error) in
            self.loadingView.removeFromSuperview()

            if  (error?.success ?? false) == false {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

    func ApproveEmpReports() {
        guard let employeesReports = selectedEmployees as? [MgrEmpReportObj] else {return}

        for items in employeesReports {

            if let reportIdIn = items.reportIdIn,
               reportIdIn != 0,
               let status = items.statusIn,
               status != 4 {
                let remark = items.remarkIn ?? ""
                self.setNewStatusReport(empId: String(UserDefaultsManager.empIdMgrReport), reportId: reportIdIn, remark: remark)
            }

            if let reportIdOut = items.reportIdOut,
               reportIdOut != 0,
               let status = items.statusOut,
               status != 4 {
                let remark = items.remarkOut ?? ""
                self.setNewStatusReport(empId: String(UserDefaultsManager.empIdMgrReport), reportId: reportIdOut, remark: remark)
            }
        }
    }

    // api call
    func updateDayReport(report: GetMgrEmpReportsObj) {
        isWaitingUpdateLoginResponse = true
        isWaitingUpdateLogoutResponse = true

        vc?.view.addSubview(loadingView)

        updateLoginReport(report: report)
        updateLogoutReport(report: report)
    }

    func updateLoginReport(report: GetMgrEmpReportsObj) {
        let date = getDateFrom(dateString: report.date, timeString: report.timeIn)

        let addMgrReport = AddMgrReporEndpoint(empId: String( UserDefaultsManager.empIdMgrReport), type: 1, date: date)
        addMgrReport.apiCall { ( error) in
            self.isWaitingUpdateLoginResponse = false
            if !self.isWaitingUpdateLogoutResponse {
                self.loadingView.removeFromSuperview()
                if (error?.success ?? false) == false {
                    NavigationController.shared?.showErrorView(error: error)
                } else {
                    self.loadData(empId: UserDefaultsManager.empIdMgrReport)
                }
            }
        }
    }

    func updateLogoutReport(report: GetMgrEmpReportsObj) {
        let date = getDateFrom(dateString: report.date, timeString: report.timeOut)

        let addMgrReport = AddMgrReporEndpoint(empId: String(UserDefaultsManager.empIdMgrReport), type: 2, date: date)
        addMgrReport.apiCall { ( error) in
            self.isWaitingUpdateLogoutResponse = false
            if !self.isWaitingUpdateLoginResponse {
                self.loadingView.removeFromSuperview()
                if (error?.success ?? false) == false {
                    NavigationController.shared?.showErrorView(error: error)
                } else {
                    self.loadData(empId: UserDefaultsManager.empIdMgrReport)
                }
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

protocol MonthEmpReportsViewModelDelegate: NSObjectProtocol {
    func didLoadData()
}
enum EmpReports {

    case reports(MgrEmpReportListItems)
    case dayReports(MgrEmpReportObj)
}
