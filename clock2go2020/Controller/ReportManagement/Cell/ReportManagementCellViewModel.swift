//
//  ReportManagementCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 3/19/20.
//

import UIKit
import GooglePlaces

class ReportManagementCellViewModel {
    private var date: Date
    
    private var report: EmpReportObj?
    private var month: MonthObj?
    private var totalHours: Double
    
    private var isExpandable: Bool
    private var isExpanded: Bool
    private var isChild: Bool
    private var isAbsence: Bool
    
    private var isMonthClosed: Bool
    
    private var healthAprove: Int?
    
    private var filterType: SortingBy
    
    private let arrowExpanded = UIImage(named: "arrow_up")
    private let arrowCollapsed = UIImage(named: "arrow_down")
    
    private var isSpecialClientDoctor: Bool {
        return CompaniesDataManager.shared.getSpecialClientType() == 1 || CompaniesDataManager.shared.getSpecialClientType() == 2
    }
    
    init(date: Date, report: EmpDayReportsObj, month: MonthObj?, isExpanded: Bool, filterType: SortingBy, isMonthClosed: Bool, totalHours: Double, healthAprove: Int?) {
        self.date = date
        self.report = EmpReportObj(dayReport: report)
        self.month = month
        self.isExpandable = (report.dayReports?.count ?? 0) > 1
        self.isExpanded = isExpanded
        self.isChild = false
        self.isAbsence = AbsenceTypeEntity.withIdentifier(Int(report.actionTypeIn ?? "0")!) != nil
        self.filterType = filterType
        self.isMonthClosed = isMonthClosed
        self.totalHours = totalHours
        self.healthAprove = healthAprove
    }
    
    init(date: Date, report: EmpReportObj, filterType: SortingBy, isMonthClosed: Bool) {
        self.date = date
        self.report = report
        self.month = nil
        self.isExpandable = false
        self.isExpanded = false
        self.isChild = true
        self.isAbsence = AbsenceTypeEntity.withIdentifier(Int(report.actionTypeIn ?? "0")!) != nil
        self.filterType = filterType
        self.isMonthClosed = isMonthClosed
        self.totalHours = 0.0
        self.healthAprove = nil
    }
    
    func getDate() -> String {
        return isChild ? " " : (report?.date?.changeDateFormat(from: "yyyy-MM-dd", to: "dd.MM") ?? " " )
    }
    func getDay() -> Int {
        //  print("ketan date =\(String(describing: report?.date?.getWeekDayNumberFormat())) Name : \(report?.date?.changeDateFormat(from: "yyyy-MM-dd", to: "EEEE"))")
        //return isChild ? " " : (report?.date?.changeDateFormat(from: "yyyy-MM-dd", to: "EEEE") ?? " " )
        return isChild ? 0 : report?.date?.getWeekDayNumberFormat() ?? 0
    }
    
    func getDayWithFirstCharacter() ->  String{
        switch getDay() {
        case 2:
            return "M".localized
        case 3:
            return "Tu".localized
        case 4:
            return "W".localized
        case 5:
            return "Th".localized
        case 6:
            return "F".localized
        case 7:
            return "Sa".localized
        case 1:
            return "Su".localized
        default:
            return ""
        }
        
    }
    //
    //    func getDayWithFirstCharacter() ->  String{
    //        switch getDay() {
    //        case "Monday":
    //            return "M".localized
    //        case "Tuesday":
    //            return "Tu".localized
    //        case "Wednesday":
    //            return "W".localized
    //        case "Thursday":
    //            return "Th".localized
    //        case "Friday":
    //            return "F".localized
    //        case "Saturday":
    //            return "Sa".localized
    //        case "Sunday":
    //            return "Su".localized
    //        default:
    //            return ""
    //        }
    //        return "";
    //    }
    
    func getHealthImage() -> UIImage? {
        guard !isChild, let healthType = healthAprove else { return nil }
        return healthType == 1 ? UIImage(named: "healthAccepted") : UIImage(named: "healthRejected")
    }
    
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
    
    func getStandardsString() -> String {
        guard let timeIn = report?.standardIn, let timeOut = report?.standardOut else { return "" }
        return timeIn + "-" + timeOut
    }
    
    func getTotalHours() -> String {
        return isAbsence ? "" : report?.totalHours?.timeFormatted() ?? "00:00"
    }
    
    func getStartTime() -> String {
        return isAbsence ? "" : report?.timeIn?.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss", to: "HH:mm") ?? "--:--"
    }
    
    func getStartStatusIcon() -> UIImage? {
        guard !isAbsence, let status = report?.statusIn, let repotStatus = ReportsStatus(rawValue: status) else { return nil }
        return repotStatus.icon
    }
    
    func getAbsenceStatusIcon() -> UIImage? {
        guard isAbsence, let status = report?.statusIn, let repotStatus = ReportsStatus(rawValue: status) else { return nil }
        return repotStatus.icon
    }
    
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
    
    func getRemarkStart() -> String {
        return report?.remarkIn ?? " "
    }
    
    func getRemarkEnd() -> String {
        return report?.remarkOut ?? " "
    }
    
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
    
    func getTrnsType() -> String {
        guard let type = report?.trnsType else { return "" }
        switch type {
        case 1:
            return "TREATMENT".localized
        case 2:
            return "EVENT_TRAINING".localized
        case 3:
            return "GENERAL_TRAINING".localized
        default:
            return ""
        }
    }
    
    var isRevacha: Bool {
        return CompaniesDataManager.shared.isRevacha()
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
        //        return !isExpandable && !isAbsence && !isMonthClosed
        //        return !isExpandable && !isAbsence && !isMonthClosed && CompaniesDataManager.shared.hasReportCompletionFeature()
        return !isExpandable && !isAbsence && !isMonthClosed && ( CompaniesDataManager.shared.hasReportEditFeature() || CompaniesDataManager.shared.hasReportDeleteFeature() )
    }
    func shouldEnableLoginTapActions() -> Bool {
        //        return !isExpandable && !isAbsence && !isMonthClosed
        //        return !isExpandable && !isAbsence && !isMonthClosed && CompaniesDataManager.shared.hasReportCompletionFeature()
        
        return !isExpandable && !isAbsence && !isMonthClosed &&  CompaniesDataManager.shared.hasReportAddFeature() && getStartTime() == "--:--"
    }
    
    func shouldEnableLogoutTapActions() -> Bool {
        //        return !isExpandable && !isAbsence && !isMonthClosed
        //        return !isExpandable && !isAbsence && !isMonthClosed && CompaniesDataManager.shared.hasReportCompletionFeature()
        return !isExpandable && !isAbsence && !isMonthClosed && CompaniesDataManager.shared.hasReportAddFeature() && getEndTime() == "--:--"
    }
    
    func shouldEnableAbsenceTapAction() -> Bool {
        return isAbsence && !isMonthClosed
    }
    
    func getTaskByName(taskName: String?) -> TaskObj? {
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        guard let task = tasks.first(where: {$0?.taskName == taskName}) else { return nil }
        return task
    }
    
    func getEventByType(eventType: String?) -> RevachaEventObj? {
        guard let eventType = eventType else { return nil }
        let events = CompaniesDataManager.shared.getEvents()
        return events?.first(where: { $0.eventType == eventType })
    }
    
    func getModelForLoginTap() -> EditReportViewModel {
        let type = report?.actionTypeIn ?? "1"
        let task = getTaskByName(taskName: report?.taskName)
        var event: RevachaEventObj?
        if CompaniesDataManager.shared.isRevacha() {
            event = getEventByType(eventType: report?.eventType)
        }
        return EditReportViewModel(reportId: report?.reportIdIn, remark: report?.remarkIn, type: type, task: task, time: report?.timeIn, date: date, trnsType: report?.trnsType, event: event)
    }
    
    func getModelForLogoutTap() -> EditReportViewModel {
        let type = report?.actionTypeOut ?? "2"
        let task = getTaskByName(taskName: report?.taskName)
        var event: RevachaEventObj?
        if CompaniesDataManager.shared.isRevacha() {
            event = getEventByType(eventType: report?.eventType)
        }
        return EditReportViewModel(reportId: report?.reportIdOut, remark: report?.remarkOut, type: type, task: task, time: report?.timeOut, date: date, trnsType: report?.trnsType, event: event)
    }
    
    func getModelForAbsenceTap() -> AbsenceReportViewModel? {
        guard let id = report?.reportIdIn, let type = report?.actionTypeIn, let date = report?.timeIn else { return nil }
        
        return AbsenceReportViewModel(absenceId: id, type: type, date: date)
    }
    
}
