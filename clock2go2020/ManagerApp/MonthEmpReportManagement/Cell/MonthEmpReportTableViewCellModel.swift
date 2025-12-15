//
//  MonthEmpReportTableViewCellModel.swift
//  clock2go2020
//
//  Created by Gleb on 02.12.2020.
//

import Foundation
import UIKit
import GooglePlaces

class MonthEmpReportTableViewCellModel {
    
    private var date: Date
    
    private var report: MgrEmpReportObj?
    private var month: MonthObj?
    private var totalHours: Double
    
    private var isExpandable: Bool
    private var isExpanded: Bool
    private var isChild: Bool
    private var isAbsence: Bool
    private var isSelected: Bool
    
    // private var healthAprove: Int?
    
    private var filterType: SortingBy
    
    private let arrowExpanded = UIImage(named: "arrow_up")
    private let arrowCollapsed = UIImage(named: "arrow_down")
    
    var empId: Int?
    
    private var isSpecialClientDoctor: Bool {
        return CompaniesDataManager.shared.getSpecialClientType() == 1 || CompaniesDataManager.shared.getSpecialClientType() == 2
    }
    
    init(date: Date, report: GetMgrEmpReportsObj, month: MonthObj?, isExpanded: Bool, filterType: SortingBy, totalHours: Double, isSelected: Bool) {
        self.date = date
        self.report = MgrEmpReportObj(dayReport: report)
        self.month = month
        self.isExpandable = (report.dayReports?.count ?? 0) > 1
        self.isExpanded = isExpanded
        self.isChild = false
        self.isAbsence = AbsenceTypeEntity.withIdentifier(Int(report.actionTypeIn ?? "0")!) != nil
        self.filterType = filterType
        self.totalHours = totalHours
        self.isSelected = isSelected
    }
    
    init(date: Date, report: MgrEmpReportObj, filterType: SortingBy, isSelected: Bool) {
        self.date = date
        self.report = report
        self.month = nil
        self.isExpandable = false
        self.isExpanded = false
        self.isChild = true
        self.isAbsence = AbsenceTypeEntity.withIdentifier(Int(report.actionTypeIn ?? "0")!) != nil
        self.filterType = filterType
        self.totalHours = 0.0
        self.isSelected = isSelected
    }
    
    // MARK: - Public func
    // Get date report
    func getDate() -> String {
        return  isChild ? " " :(report?.date?.changeDateFormat(from: "yyyy-MM-dd", to: "dd.MM") ?? " " )
    }
    
    func getSelectedImage() -> UIImage? {
        return isSelected ? UIImage(named: "checked_terms") : UIImage(named: "unchecked_terms")
    }
    
    // Get Absence info
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
    
    func getAbsenceString() -> String {
        return AbsenceTypeEntity.init(rawValue: report?.actionTypeIn ?? "")?.absenceTitle ?? "היעדרות"
    }
    
    func getAbsenceStatusIcon() -> UIImage? {
        guard isAbsence, let status = report?.statusIn, let repotStatus = ReportsStatus(rawValue: status) else { return nil }
        return repotStatus.icon
    }
    
    func getStandardsString() -> String {
        guard let timeIn = report?.standardIn, let timeOut = report?.standardOut else { return "" }
        return timeIn + "-" + timeOut
    }
    
    func getTotalHours() -> String {
        return isAbsence ? "" : report?.totalHours?.timeFormatted() ?? "00:00"
    }
    
    func getCummulativeTimeString() -> String {
        if isChild || isAbsence {
            return " "
        }
        
        switch filterType {
        case .missings, .absences, .breaks, .noReport:
            return ""
        case .standards, .allReports:
            return totalHours.description.timeFormatted()
        }
    }
    
    // get start
    func getStartTime() -> String {
        return isAbsence ? "" : report?.timeIn?.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss", to: "HH:mm") ?? "--:--"
    }
    
    func getStartStatusIcon() -> UIImage? {
        guard !isAbsence, let status = report?.statusIn, let repotStatus = ReportsStatus(rawValue: status) else { return nil }
        return repotStatus.icon
    }
    
    // get end
    func getStartColor() -> UIColor? {
        return isAbsence ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : getColorByActionType(report?.actionTypeIn) ?? #colorLiteral(red: 0.2010920346, green: 0.7715099454, blue: 0.4828107357, alpha: 0.5)
    }
    
    func getEndTime() -> String {
        return isAbsence ? "" : report?.timeOut?.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss", to: "HH:mm") ?? "--:--"
    }
    
    func getEndStatusIcon() -> UIImage? {
        guard !isAbsence, let status = report?.statusOut, let repotStatus = ReportsStatus(rawValue: status) else { return nil }
        return repotStatus.icon
    }
    
    func getEndColor() -> UIColor? {
        return isAbsence ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : getColorByActionType(report?.actionTypeOut) ?? #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 0.5)
    }
    
    func getReportIdIn() -> Int {
        return report?.reportIdIn ?? 0
    }
    
    func getReportIdOut() -> Int {
        return report?.reportIdOut ?? 0
    }
    
    // get remark
    func getRemarkStart() -> String {
        return report?.remarkIn ?? " "
    }
    
    func getRemarkEnd() -> String {
        return report?.remarkOut ?? " "
    }
    
    // get location
    func getLocationStartString() -> String {
        if isSpecialClientDoctor, let title = getSpecialClientLocationTitle(type: report?.actionTypeIn) {
            return title
        }
        return isAbsence ? "" : report?.locationIn ?? " "
    }
    
    func getLocationStart() -> CLLocation? {
        guard let lat = Double(report?.latIn ?? ""), let lon = Double(report?.lonIn ?? "") else { return nil }
        
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    func getLocationEndString() -> String {
        if isSpecialClientDoctor, let title = getSpecialClientLocationTitle(type: report?.actionTypeOut) {
            return title
        }
        return report?.locationOut ?? " "
    }
    
    func getLocationEnd() -> CLLocation? {
        guard let lat = Double(report?.latOut ?? ""), let lon = Double(report?.lonOut ?? "") else { return nil }
        
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    // get spacial cient locaion
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
    
    func getBackgroundColor() -> UIColor? {
        return isExpandable ? #colorLiteral(red: 0.7921568627, green: 0.8274509804, blue: 0.8509803922, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func getChildBackgroundColor() -> UIColor? {
        return isChild ? #colorLiteral(red: 0.892903626, green: 0.9147248864, blue: 0.9293224216, alpha: 1) :  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    func getTaskBackgroundColor() -> UIColor? {
        return isAbsence ? #colorLiteral(red: 0.6731665134, green: 0.6732652783, blue: 0.673144877, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    func getTaskTextColor() -> UIColor? {
        return isAbsence ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.0862745098, green: 0.3019607843, blue: 0.4352941176, alpha: 1)
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
    
    func getExpandedImage() -> UIImage? {
        return isExpandable ? (isExpanded ? arrowExpanded : arrowCollapsed) : nil
    }
    
    func shouldEnableTapActions() -> Bool {
        return !isExpandable && !isAbsence  && CompaniesDataManager.shared.hasReportCompletionFeature()
    }
    
    func shouldEnableAbsenceTapAction() -> Bool {
        return isAbsence
    }
    func getTaskByName(taskName: String?) -> TaskObj? {
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        guard let task = tasks.first(where: {$0?.taskName == taskName}) else { return nil }
        return task
    }
    
    // MARK: - Model for Editor Report View
    func getModelForLoginTap(reportIsEmptry: Bool) -> EditReportViewModel {
        let type = report?.actionTypeIn ?? "1"
        let task = report?.taskName
        return EditReportViewModel(reportId: report?.reportIdIn, statusReport: report?.statusIn, mgrEmpId: self.empId, remark: report?.remarkIn, mgrType: Int(type) ?? 1, empTaskName: task, time: report?.timeIn, date: date, reportIsEmpty: reportIsEmptry)
    }
    
    func getModelForLogOutTap(reportIsEmptry: Bool) -> EditReportViewModel {
        let type = report?.actionTypeOut ?? "2"
        let task = report?.taskName
        
        return EditReportViewModel(reportId: report?.reportIdOut, statusReport: report?.statusOut, mgrEmpId: self.empId, remark: report?.remarkOut, mgrType: Int(type) ?? 2, empTaskName: task, time: report?.timeOut, date: date, reportIsEmpty: reportIsEmptry)
    }
    
    func getModelForAbsenceTap() -> AbsenceReportViewModel? {
        guard let id = report?.reportIdIn, let type = report?.actionTypeIn, let date = report?.timeIn else { return nil }
        return AbsenceReportViewModel(absenceId: id, type: type, date: date)
    }
}
