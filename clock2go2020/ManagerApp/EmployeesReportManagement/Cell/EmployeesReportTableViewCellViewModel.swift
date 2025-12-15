//
//  EmployeesReportTableViewCellViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 16.09.2020.
//

import Foundation
import UIKit
import GooglePlaces

class EmployeesReportTableViewCellViewModel {
    
    // MARK: - Private var
    private var report: MgrDayReport?
    private var date: Date
    private var month: MonthObj?
    private var isChild: Bool
    private var isExpandable: Bool
    private var isExpanded: Bool
    private var isAbsence: Bool
    private let arrowExpanded = #imageLiteral(resourceName: "arrow_Up")
    private let arrowCollapsed = #imageLiteral(resourceName: "arrow_down")
    private var totalHours: String
    private var filterType: SortingBy
    private var isSelected: Bool
    private var empId: Int
    
    private var isSpecialClientDoctor: Bool {
        return CompaniesDataManager.shared.getSpecialClientType() == 1 || CompaniesDataManager.shared.getSpecialClientType() == 2
    }
    
    // MARK: - Init
    init(date: Date, report: MgrDayReportsObj, filterType: SortingBy, month: MonthObj?, isExpanded: Bool, totalHours: String, isSelected: Bool ) {
        self.report  = MgrDayReport(dayReports: report)
        self.isExpandable = (report.dayReports.count ) > 1
        self.isExpanded = isExpanded
        self.date    = date
        self.month   = month
        self.isChild = false
        self.filterType = filterType
        self.isAbsence = AbsenceTypeEntity.withIdentifier(Int(report.actionTypeIn ?? "0") ?? 0) != nil
        self.totalHours = totalHours
        self.isSelected = isSelected
        self.empId = 0
    }
    
    init(empId: Int, date: Date, report: MgrDayReportsObj, filterType: SortingBy, month: MonthObj?, isExpanded: Bool, totalHours: String, isSelected: Bool ) {
        self.report  = MgrDayReport(dayReports: report)
        self.isExpandable = (report.dayReports.count ) > 1
        self.isExpanded = isExpanded
        self.date    = date
        self.month   = month
        self.isChild = false
        self.filterType = filterType
        self.isAbsence = AbsenceTypeEntity.withIdentifier(Int(report.actionTypeIn ?? "0") ?? 0) != nil
        self.totalHours = totalHours
        self.isSelected = isSelected
        self.empId = empId
    }
    
    init(date: Date, report: MgrDayReport, filterType: SortingBy, totalHours: String, isSelected: Bool ) {
        self.date = date
        self.report = report
        self.month = nil
        self.isExpandable = false
        self.isExpanded = false
        self.isChild = true
        self.filterType = filterType
        self.isAbsence = AbsenceTypeEntity.withIdentifier(Int(report.actionTypeIn ?? "0") ?? 0) != nil
        self.totalHours = totalHours
        self.isSelected = isSelected
        self.empId = 0
    }
    
    // MARK: - Public func
    func getSelectedImage() -> UIImage? {
        return isSelected ? UIImage(named: "checked_terms") : UIImage(named: "unchecked_terms")
    }
    
    // Get date report
    func getDate() -> String {
        return  isChild ? " " :(report?.date?.changeDateFormat(from: "yyyy-MM-dd", to: "dd.MM") ?? " " )
    }
    
    func getAbsenceString() -> String {
        return AbsenceTypeEntity.init(rawValue: report?.actionTypeIn ?? "")?.absenceTitle ?? "Absence Title"
    }
    
    func getAbsenceStatusIcon() -> UIImage? {
        guard isAbsence, let status = report?.statusIn, let repotStatus = ReportsStatus(rawValue: status) else { return nil }
        return repotStatus.icon
    }
    
    func getEndStatusIcon() -> UIImage? {
        guard !isAbsence, let status = report?.statusOut, let repotStatus = ReportsStatus(rawValue: status) else { return nil }
        return repotStatus.icon
    }
    
    // Get employee ID
    func getEmpId() -> Int {
        return report?.empId ?? 0
    }
    
    // Get employee name
    func getEmpName() -> String {
        return report?.empName ?? ""
    }
    
    // Get task name
    func getTaskName() -> String {
        if isAbsence {
            return getAbsenceString()
        }
        
        switch filterType {
        case .standards:
            return getStandardsString()
        case .allReports, .breaks, .absences, .missings, .noReport:
            return report?.taskName ?? " "
        }
        
    }
    
    func getStandardsString() -> String {
        guard let timeIn = report?.timeIn, let timeOut = report?.timeOut else { return "" }
        return timeIn + "-" + timeOut
    }
    // Get total hours report
    func getTotalHours() -> String {
        if  isAbsence {
            return " "
        }
        return totalHours.timeFormatted()
    }
    
    // Get cummulativeTime
    func getCummulativeTimeString() -> String {
        if  isAbsence {
            return " "
        }
        
        switch filterType {
        case .missings, .absences, .breaks, .noReport:
            return ""
        case .standards, .allReports:
            return totalHours.timeFormatted()
        }
    }
    
    // Get report ID In
    func getReportIdIn() -> Int {
        return report?.reportIdIn ?? 0
    }
    
    // Get start time
    func getStartTime() -> String {
        return isAbsence ? "" : report?.timeIn?.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss", to: "HH:mm") ?? "--:--"
    }
    
    // Get action type In
    func getActionTypeIn() -> String {
        return report?.actionTypeIn ?? ""
    }
    
    // Get remark In
    func getRemarkIn() -> String {
        return report?.remarkIn ?? ""
    }
    
    // Get location In
    func getLocationStartString() -> String {
        if isSpecialClientDoctor, let title = getSpecialClientLocationTitle(type: report?.actionTypeIn) {
            return title
        }
        return isAbsence ? "" : report?.locationIn ?? " "
    }
    
    // Get coordinate In
    func getLocationStart() -> CLLocation? {
        guard let lat = Double(report?.latIn ?? ""), let lon = Double(report?.lonIn ?? "") else { return nil }
        
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    // Get status In
    func getStatusIn() -> Int {
        return report?.statusIn ?? 0
    }
    
    // Get report ID Out
    func getReportIdOut() -> Int {
        return report?.reportIdOut ?? 0
    }
    
    // Get end time
    func getEndTime() -> String {
        return isAbsence ? "" : report?.timeOut?.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss", to: "HH:mm") ?? "--:--"
    }
    
    // Get action type Out
    func getActionTypeOut() -> String {
        return report?.actionTypeOut ?? ""
    }
    
    // Get remark Out
    func getRemarkOut() -> String {
        return report?.remarkOut ?? ""
    }
    
    // Get location Out
    func getLocationEndString() -> String {
        if isSpecialClientDoctor, let title = getSpecialClientLocationTitle(type: report?.actionTypeOut) {
            return title
        }
        return report?.locationOut ?? " "
    }
    
    // Get coordinate Out
    func getLocationEnd() -> CLLocation? {
        guard let lat = Double(report?.latOut ?? ""), let lon = Double(report?.lonOut ?? "") else { return nil }
        
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    // Get status Out
    func getStatusOut() -> Int {
        return report?.statusOut ?? 0
    }
    
    func getExpandedImage() -> UIImage? {
        return isExpandable ? (isExpanded ? arrowExpanded : arrowCollapsed) : nil
    }
    
    func getBackgroundColor() -> UIColor? {
        return isExpandable ? #colorLiteral(red: 0.7921568627, green: 0.8274509804, blue: 0.8509803922, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func getChildBackgroundColor() -> UIColor? {
        return isChild ? #colorLiteral(red: 0.892903626, green: 0.9147248864, blue: 0.9293224216, alpha: 1) :  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    func getTaskBackgroundColor() -> UIColor? {
        return isAbsence ? #colorLiteral(red: 0.6731665134, green: 0.6732652783, blue: 0.673144877, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    func getStartColor() -> UIColor? {
        return isAbsence ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : getColorByActionType(report?.actionTypeIn) ?? #colorLiteral(red: 0.2010920346, green: 0.7715099454, blue: 0.4828107357, alpha: 0.5)
    }
    
    func getTaskTextColor() -> UIColor? {
        return isAbsence ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.0862745098, green: 0.3019607843, blue: 0.4352941176, alpha: 1)
    }
    
    func getEndColor() -> UIColor? {
        return isAbsence ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : getColorByActionType(report?.actionTypeOut) ?? #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 0.5)
    }
    
    func getColorByActionType(_ type: String?) -> UIColor? {
        
        if type == "1" {
            return #colorLiteral(red: 0.2010920346, green: 0.7715099454, blue: 0.4828107357, alpha: 0.5)
        } else if type == "2" {
            return #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 0.5)
        } else if type == "98" {
            return #colorLiteral(red: 0.9773489833, green: 0.4326385856, blue: 0.8032094836, alpha: 0.5)
        } else if type == "99" {
            return #colorLiteral(red: 0.9866847396, green: 0.7379429936, blue: 0.9088150859, alpha: 0.5)
        }
        
        return nil
    }
    func getSpecialClientLocationTitle(type: String?) -> String? {
        if CompaniesDataManager.shared.getSpecialClientType() == 1 ||
            CompaniesDataManager.shared.getSpecialClientType() == 2 {
            if type == "1" {
                return "Login"
            } else if type == "2" {
                return "Logout"
            }
            
            guard let additionalButtons = CompaniesDataManager.shared.getAddonButtons(),
                  let additionalButton1ActionType = additionalButtons.button_1?.action_type?.description,
                  let additionalButton2ActionType = additionalButtons.button_2?.action_type?.description else { return nil }
            
            if type == additionalButton1ActionType {
                return additionalButtons.button_1?.text
            } else if type == additionalButton2ActionType {
                return additionalButtons.button_2?.text
            }
        }
        
        return nil
    }
    
    func shouldEnableLocationTapAction() -> Bool {
        return !isSpecialClientDoctor
    }
    
    func shouldEnableTapActions() -> Bool {
        return !isExpandable && !isAbsence && CompaniesDataManager.shared.hasReportCompletionFeature()
    }
    
    func shouldEnableAbsenceTapAction() -> Bool {
        return isAbsence
    }
    
    func getStartStatusIcon() -> UIImage? {
        guard !isAbsence, let status = report?.statusIn, let repotStatus = ReportsStatus(rawValue: status) else { return nil }
        return repotStatus.icon
    }
    
    // MARK: - Model for Editor Report View
    func getModelForLoginTap(reportIsEmptry: Bool) -> EditReportViewModel {
        let type = report?.actionTypeIn ?? "1"
        let task = report?.taskName
        return EditReportViewModel(reportId: report?.reportIdIn, statusReport: report?.statusIn, mgrEmpId: report?.empId, remark: report?.remarkIn, mgrType: Int(type) ?? 1, empTaskName: task, time: report?.timeIn, date: date, reportIsEmpty: reportIsEmptry)
    }
    
    func getModelForLogOutTap(reportIsEmptry: Bool) -> EditReportViewModel {
        let type = report?.actionTypeOut ?? "2"
        let task = report?.taskName
        return EditReportViewModel(reportId: report?.reportIdOut, statusReport: report?.statusOut, mgrEmpId: report?.empId, remark: report?.remarkOut, mgrType: Int(type) ?? 2, empTaskName: task, time: report?.timeOut, date: date, reportIsEmpty: reportIsEmptry)
    }
    
    func getModelForAbsenceTap() -> AbsenceReportViewModel? {
        guard let id = report?.reportIdIn, let type = report?.actionTypeIn, let date = report?.timeIn else { return nil }
        return AbsenceReportViewModel(absenceId: id, type: type, date: date)
    }
    
}
