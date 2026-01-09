//
//  ReportManagementViewModel.swift
//  clock2go2020
//
//  Created by Admin on 3/10/20.
//

import UIKit

class ReportManagementViewModel {
    
    private var isClosed: Bool = false
    private var reportListItems: [ReportListItem] = []
    
    private var filterType: SortingBy = .allReports
    private var isFilterActivated: Bool = false
    private var filteredListItems: [ReportListItem] = []
    private var filteredDays: [String]? = []
    
    private var days: [String]? = []
    
    private var monthObj: MonthObj?
    
    var isWaitingUpdateLoginResponse = false
    var isWaitingUpdateLogoutResponse = false
    
    weak var delegate: ReportManagementViewModelDelegate?
    
    var month: String
    var monthTitle: String = ""
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    
    init(date: Date = Date()) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")
        
        self.month = date.toString(format: "yyyy-MM")
        var monthIndex = calendar.component(.month, from: date)
        
        if CompaniesDataManager.shared.getSpecialClientType() == 1 {
            monthIndex -= 1
            if monthIndex == 0 {
                monthIndex = 12
            }
            let date = self.getDateForMonthIndex(index: monthIndex)
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
        guard var selectedDate = Calendar.current.date(bySetting: .month, value: index, of: Date()) else {
            return Date()
        }
        
        if Date().months(from: selectedDate) < 0 {
            selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? Date()
        }
        
        return selectedDate
    }
    
    func loadData() {
        vc?.view.addSubview(loadingView)
        
        let getEmpReports = GetEmployeeReportsEndpoint(month: month)
        getEmpReports.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                print("Get Employee Reports: success")
                
                self.isClosed = result?.isClosed ?? false
                self.setReports(reports: result?.reports)
            } else {
                NavigationController.shared?.showErrorView(error: error)
                print("Get Employee Reports: failed")
            }
        }
    }
    
    func closeMonth() {
        isClosed = true
        delegate?.didLoadData()
    }
    
    func setReportsObj(_ reportsObj: EmpReportsObj?) {
        guard let isClosed = reportsObj?.isClosed else { return }
        self.isClosed = isClosed
        setReports(reports: reportsObj?.reports)
    }
    
    func setReports(reports: [String: EmpDayReportsObj]?) {
        unfilterList()
        
        guard let reportsList = reports else { return }
        
        reportListItems = []
        
        for report in reportsList {
            reportListItems.append(ReportListItem(day: report.key, report: report.value))
        }
        
        if reports != nil {
            let daysArray = Array(reports!.keys)
            
            self.days = daysArray.sorted()
        }
        
        delegate?.didLoadData()
    }
    
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
    
    func getMissings() -> [ReportListItem] {
        var missings: [ReportListItem] = []
        var days: [String] = []
        
        for reportListItem in reportListItems {
            
            guard let reportItem = reportListItem.copy() as? ReportListItem else { return [] }
            
            if let report = reportItem.report {
                if AbsenceTypeEntity.withIdentifier(Int(report.actionTypeIn ?? "0")!) == nil {
                    var timeIn = String()
                    var timeOut = String()
                    if let str = report.timeIn, str.count > 0 {
                        timeIn = str
                    }
                    if let str = report.timeOut, str.count > 0 {
                        timeOut = str
                    }
                    
                    if timeIn.count == 0 && timeOut.count == 0 {
                        print(reportItem)
                    }else if timeIn.count > 0 && timeOut.count > 0 {
                        if let arr = report.dayReports, arr.count > 0 {
                            let filteredReports = arr.filter { reportDict in
                                var strtimeIn = String()
                                var strtimeOut = String()
                                
                                if let str = reportDict.timeIn, str.count > 0 {
                                    strtimeIn = str
                                }
                                
                                if let str = reportDict.timeOut, str.count > 0 {
                                    strtimeOut = str
                                }
                                
                                if strtimeIn.count == 0 && strtimeOut.count == 0 {
                                    return false
                                }else if strtimeIn.count == 0 || strtimeOut.count == 0 {
                                    return true
                                }
                                return false
                            }
                            
                            if filteredReports.count > 0 {
                                missings.append(reportItem)
                                if let day = reportItem.day {
                                    days.append(day)
                                }
                            }
                        }
                    }else if timeIn.count == 0 || timeOut.count == 0 {
                        missings.append(reportItem)
                        if let day = reportItem.day {
                            days.append(day)
                        }
                    }
                }
            }
        }
        
        filteredDays = days.sorted()
        return missings
    }
    
    func getAbsences() -> [ReportListItem] {
        var absences: [ReportListItem] = []
        var days: [String] = []
        
        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? ReportListItem else { return [] }
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
    
    func getBreaks() -> [ReportListItem] {
        var breaks: [ReportListItem] = []
        var days: [String] = []
        
        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? ReportListItem else { return [] }
            if reportItem.report?.actionTypeIn == "99" || reportItem.report?.actionTypeIn == "98" || reportItem.report?.actionTypeOut == "99" || reportItem.report?.actionTypeOut == "98" {
                
                let reports = reportItem.descendants.filter({($0.actionTypeIn == "99" || $0.actionTypeIn == "98" || $0.actionTypeOut == "99" || $0.actionTypeOut == "98" )})
                if reports.count > 1 {
                    reportItem.descendants = reports
                }
                
                breaks.append(reportItem)
                
                if let day = reportItem.day {
                    days.append(day)
                }
            } else {
                let reports = reportItem.descendants.filter({($0.actionTypeIn == "99" || $0.actionTypeIn == "98" || $0.actionTypeOut == "99" || $0.actionTypeOut == "98" )})
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
    
    func getNoReports() -> [ReportListItem] {
        var missings: [ReportListItem] = []
        var days: [String] = []
        
        for reportListItem in reportListItems {
            guard let reportItem = reportListItem.copy() as? ReportListItem else { return [] }
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
    
    func unfilterList() {
        isFilterActivated = false
        filteredListItems = []
        filteredDays = []
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
    
    func getModelForItemAt(section: Int, row: Int) -> ReportManagementCellViewModel? {
        let reportsArray = isFilterActivated ? filteredListItems : reportListItems
        let daysArray = isFilterActivated ? filteredDays : days
        
        if reportsArray.indices.contains(section) {
            if row == 0 {
                if let day = daysArray?[section],
                   let reportItem = reportsArray.first(where: { $0.day == day }),
                   let report = reportItem.report,
                   let date = day.getDateFromStringWithFormat("yyyy-MM-dd") {
                    let hours = getCummulativeTotalHoursFor(section: section)
                    return ReportManagementCellViewModel(date: date, report: report, month: monthObj, isExpanded: reportItem.isExpanded, filterType: filterType, isMonthClosed: isClosed, totalHours: hours, healthAprove: report.healthDisclaimerAccepted)
                }
            } else {
                if let day = daysArray?[section], let reportItem = reportsArray.first(where: { $0.day == day }), reportItem.descendants.indices.contains(row - 1), let date = day.getDateFromStringWithFormat("yyyy-MM-dd") {
                    let report = reportItem.descendants[row - 1]
                    return ReportManagementCellViewModel(date: date, report: report, filterType: filterType, isMonthClosed: isClosed)
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
    
    func getModelForActionView() -> ReportActionViewModel {
        // let hasMissingReports = getMissings().count > 0
        let hasMissingReports = monthObj?.misses ?? 0 > 0
        return ReportActionViewModel(type: filterType, month: month, isClosed: isClosed, hasMissingReports: hasMissingReports)
    }
    
    // api call
    
    func updateDayReport(report: EmpDayReportsObj) {
        isWaitingUpdateLoginResponse = true
        isWaitingUpdateLogoutResponse = true
        
        vc?.view.addSubview(loadingView)
        
        updateLoginReport(report: report)
        updateLogoutReport(report: report)
    }
    
    func updateLoginReport(report: EmpDayReportsObj) {
        let date = getDateFrom(dateString: report.date, timeString: report.timeIn)
        let reportId = report.reportIdIn
        let remark = report.remarkIn
        let taskId = getTaskIdByName(report.taskName)
        let extraFields = report.extraFields
        
        let updateLogin = UpdateEmpReportEndpoint(type: "1", date: date, reportId: reportId, remark: remark, taskId: taskId, taskName: report.taskName, extraFields: extraFields)
        updateLogin.apiCall { (result, error) in
            self.isWaitingUpdateLoginResponse = false
            if !self.isWaitingUpdateLogoutResponse || report.eventType != nil {
                self.loadingView.removeFromSuperview()
                
                if error?.success ?? false {
                    self.loadData()
                } else {
                    NavigationController.shared?.showErrorView(error: error)
                }
            }
        }
    }
    
    func updateLogoutReport(report: EmpDayReportsObj) {
        let date = getDateFrom(dateString: report.date, timeString: report.timeOut)
        let reportId = report.reportIdOut
        let extraFields = report.extraFields
        let taskId = getTaskIdByName(report.taskName)
        
        let updateLogin = UpdateEmpReportEndpoint(type: "2", date: date, reportId: reportId, taskId: taskId, taskName: report.taskName, extraFields: extraFields)
        updateLogin.apiCall { (_, error) in
            self.isWaitingUpdateLogoutResponse = false
            if !self.isWaitingUpdateLoginResponse {
                self.loadingView.removeFromSuperview()
                
                if error?.success ?? false {
                    self.loadData()
                } else {
                    NavigationController.shared?.showErrorView(error: error)
                }
            }
            
        }
    }
}

protocol ReportManagementViewModelDelegate: NSObjectProtocol {
    func didLoadData()
}
