//
//  EditReportViewModel.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/26/20.
//

import Foundation
import UIKit
import  AnyCodable

class EditReportViewModel {
    private var reportId: Int?
    private var remark: String?
    private var type: String?
    private var task: TaskObj?
            var date: Date?
    private var time: String?
    private var empTaskName: String?
    private var mgrEmpId: Int?
    private var mgrType: Int?
    private var statusReport: Int?
    private var showReject: Bool
    private var trnsType: Int?
    private var therapyType: Int?
    private var event: RevachaEventObj?

    var reportIsEmpty: Bool?
    var monthReportsEmp: Bool = false

    var delegate: EditReportViewModelDelegate?

    var updateReports: ((_ empReports: [String: EmpDayReportsObj]?) -> ())?
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    
    init(reportId: Int?, remark: String?, type: String, task: TaskObj?, time: String?, date: Date, trnsType: Int?, event: RevachaEventObj?) {
        self.reportId = reportId
        self.remark = remark
        self.type = type
        self.task = task
        self.empTaskName = ""
        self.mgrEmpId = 0
        self.mgrType = 0
        self.statusReport = nil
        self.showReject   = true
        self.trnsType = trnsType
        self.event = event
        
        if let reportDate = time?.getDateFromStringWithFormat("yyyy-MM-dd HH:mm:ss") {
            self.date = reportDate
            self.time = self.date?.toString(format: "HH:mm")
        } else {
            self.date = date
            self.time = nil
        }
        
        
    }

    // MARK: Init for management reports
    init(reportId: Int?, statusReport: Int?, mgrEmpId: Int?, remark: String?, mgrType: Int?, empTaskName: String?, time: String?, date: Date, reportIsEmpty: Bool) {
        self.reportId = reportId
        self.remark = remark
        self.mgrType = mgrType
        self.task = nil
        self.empTaskName =  empTaskName
        self.mgrEmpId = mgrEmpId
        self.type = String(mgrType ?? 0)
        self.statusReport = statusReport
        self.showReject   = false
        self.reportIsEmpty = reportIsEmpty

        if let reportDate = time?.getDateFromStringWithFormat("yyyy-MM-dd HH:mm:ss") {
            self.date = reportDate
            self.time = self.date?.toString(format: "HH:mm")
        } else {
            self.date = date
            self.time = nil
        }
    }
    var isRevacha: Bool {
        return CompaniesDataManager.shared.isRevacha()
    }
    
    var isHolocust: Bool {
        return CompaniesDataManager.shared.isHolocaustSurvivors()
    }
    
    var reportCompletionNote: Bool {
        return CompaniesDataManager.shared.getReportCompletionNote() == 1 ? true : false
    }
    
    func getRemark() -> String {
        return remark ?? ""
    }

    func setRemark(remark: String) {
        self.remark = remark
    }

    func getTask() -> String {
        if isRevacha || isHolocust {
            return shouldEnableTask() ? task?.taskName ?? "SELECT_CLIENT".localized : "SELECT_CLIENT".localized
        }
        return shouldEnableTask() ? task?.taskName ?? "SELECT_TASK".localized : "SELECT_TASK".localized
    }
    
    func getIntTrnsType() -> Int {
        return self.trnsType ?? 3
    }
    
    func getIntTherapyType() -> Int {
        return self.therapyType ?? 1
    }
    
    func getTrnsType() -> String {

        switch trnsType {
        case 1:
            return "TREATMENT".localized
        case 2:
            return "EVENT_TRAINING".localized
        case 3:
            return "GENERAL_TRAINING".localized
        default:
            return "TRNS_TYPE".localized
        }
       
    }
    
    func getHoloCustTrnsType() -> String {
        switch trnsType {
        case 1:
            return "On_site_treatment".localized
        case 2:
            return "Online".localized
        case 3:
            return "Clinic_treatment".localized
        default:
            return "TRNS_TYPE".localized
        }
    }
    
    func getHoloCustTherapyType() -> String {
        switch therapyType {
        case 1:
            return "Medical".localized
        case 2:
            return "Group".localized
        case 3:
            return "Projective".localized
        case 4:
            return "Individual".localized
        default:
            return "Select_Therapy".localized
        }
    }
    
    func buttonsShouldBeDisabled() -> Bool {
        return trnsType == 3
    }
    
    func eventButtonHidden() -> Bool {
        return type == "2"
    }
    
    func getEventName() -> String {
        return event?.eventName ?? "SELECT_CLIENT".localized
    }
    
    func getReportType() -> String? {
        return type
    }
    
    func setTrnsType(type:Int?) {
        trnsType = type
    }
    
    func setTheraphyType(type:Int?) {
        therapyType = type
    }
    
    func setTask(task: TaskObj) {
        self.task = task
    }

    func setEvent(_ event: RevachaEventObj?) {
        self.event = event
    }

    func getTaskColor() -> UIColor {
        return shouldEnableTask() ? #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }

    func shouldEnableTask() -> Bool {
        return type == "1" || type == "2"
    }

    func getTime() -> String {
        return time ?? "--:--"
    }

    func setTime(time: String) {
        self.time = time
    }

    func getMgrEmployeeId() -> Int {
        return mgrEmpId ?? 0
    }

    func getReportIsEmpty() -> Bool {
        return reportIsEmpty ?? false
    }

    func getColor() -> UIColor? {
        if type == "1" {
            return #colorLiteral(red: 0.2010920346, green: 0.7715099454, blue: 0.4828107357, alpha: 1)
        } else if type == "2" {
            return #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 1)
        } else if type == "98" {
            return #colorLiteral(red: 0.9773489833, green: 0.4326385856, blue: 0.8032094836, alpha: 1)
        } else if type == "99" {
            return #colorLiteral(red: 0.9866847396, green: 0.7379429936, blue: 0.9088150859, alpha: 1)
        }

        if let color = getSpecialClientBackgroundColor() {
            return color
        }

        if let color = getAdditionalBackgroundColor() {
            return color
        }

        return nil
    }

    func getSpecialClientBackgroundColor() -> UIColor? {
        if (CompaniesDataManager.shared.getSpecialClientType() == 1 ||
                CompaniesDataManager.shared.getSpecialClientType() == 2),
           let additionalButtons = CompaniesDataManager.shared.getAddonButtons(),
           let additionalButton1ActionType = additionalButtons.button_1?.action_type?.description,
           let additionalButton2ActionType = additionalButtons.button_2?.action_type?.description {

            if type == additionalButton1ActionType {
                return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
            } else if type == additionalButton2ActionType {
                return #colorLiteral(red: 0.9756608605, green: 0.3157561719, blue: 0.3174736798, alpha: 1)
            }
        }

        return nil
    }

    func getAdditionalBackgroundColor() -> UIColor? {
        if  let additionalButtons = CompaniesDataManager.shared.getAddonButtons() {

            let additionalButton1ActionType = additionalButtons.button_1?.action_type?.description ?? ""
            let additionalButton2ActionType = additionalButtons.button_2?.action_type?.description ?? ""
            let additionalButton3ActionType = additionalButtons.button_3?.action_type?.description ?? ""
            let additionalButton4ActionType = additionalButtons.button_4?.action_type?.description ?? ""

            if type == additionalButton1ActionType || type == additionalButton3ActionType {
                return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
            } else if type == additionalButton2ActionType || type == additionalButton4ActionType {
                return #colorLiteral(red: 0.9756608605, green: 0.3157561719, blue: 0.3174736798, alpha: 1)
            }
        }

        return nil
    }

    func shouldShowChooseTaskView() -> Bool {
        if isRevacha {
            return false 
        }
        return CompaniesDataManager.shared.hasChooseTaskFeature()
    }

    func shouldShowRevachaView() -> Bool {
        return isRevacha
    }
    
    func shouldShowRemoveView() -> Bool {
        return reportId != nil && CompaniesDataManager.shared.hasReportDeleteFeature()
    }
    
    private func shouldAddNote() -> Bool {
        return CompaniesDataManager.shared.getReportCompletionNote() == 1
    }

    func shouldShowTaskError() -> Bool {
        if isRevacha && (type == "1" || type == "2") && (trnsType == 3  ) {
            return false
        }
        if isRevacha && (type == "1" || type == "2") && (trnsType == nil || trnsType == 0 ||  task == nil ) {
            return true
        }
      
        if CompaniesDataManager.shared.shouldReportTask() && task == nil && (type == "1" || type == "2") {
            return true
        }

        return false
    }
    
    func shouldShowRemarkError() -> Bool {
        return shouldAddNote() && (remark == nil || remark == "")
    }
    
    func shouldShowDateError() -> Bool {
        return date == nil
    }
    
    func shouldShowTimeError() -> Bool {
        return (time == nil || time == "--:--")
    }


    func getDateForReport() -> Date? {
        guard let hours = time?.getHourComponent(), let minutes = time?.getMinuteComponent(), let date = self.date else { return nil }
        let seconds = 0

        return Calendar.current.date(bySettingHour: hours, minute: minutes, second: seconds, of: date)
    }

    func shouldShowRejectButton() -> Bool {
        return showReject
    }

    // api call
    func  saveReport() {
        guard let date = getDateForReport() else { return }

        vc?.view.addSubview(loadingView)

        let saveReport = UpdateEmpReportEndpoint(type: type, date: date.toString(format: "yyyy-MM-dd HH:mm:ss"), reportId: reportId, remark: remark, taskId: task?.taskId, extraFields: ["trnsType" : trnsType ?? 0, "EventType" : event?.eventType ?? ""])
        saveReport.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            if error?.success ?? false {
                self.delegate?.didEditReport(result)
                self.updateReports?(result)
            } else {
                self.delegate?.didReceiveError(error)
            }
        }
    }

    func removeReport() {
        vc?.view.addSubview(loadingView)

        let deleteReport = DeleteEmpReportEndpoint(reportId: reportId)
        deleteReport.apiCall { result, error in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                self.delegate?.didRemoveReport(result)
                self.updateReports?(result)
            } else {
                self.delegate?.didReceiveError(error)
            }
        }
    }

    // Api call Mgr
    func saveMgrReport(status: Int) {
        guard let date = getDateForReport() else { return }
        /// 4  Approve
        if status == 4 {
            let saveReport = UpdateMgrReportsEndpoint(empId: mgrEmpId ?? 0, reportId: reportId ?? 0, type: mgrType ?? 0, date: date.toString(format: "yyyy-MM-dd HH:mm:ss"))
            saveReport.apiCall { (error)  in
                if (error?.success ?? false) == false {
                    NavigationController.shared?.showErrorView(error: error)
                } else {
                    self.setNewStatusReport(status: status)
                }
            }
            /// 3 Reject
        } else if status == 3 {
            self.setNewStatusReport(status: status)
        }
    }

    func setNewStatusReport(status: Int) {
        // Set status for update report
        let setStatusReport = SetReportStatus(empId: String(self.mgrEmpId ?? 0), reportId: self.reportId ?? 0, status: status, remark: self.remark ?? "")
        setStatusReport.apiCall { [self] (error) in
            if  (error?.success ?? false) == false {
                NavigationController.shared?.showErrorView(error: error)
            } else {
                if !monthReportsEmp {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editMonthReporEmp"), object: nil)
                }
            }
        }
    }

    func removeMgrReport() {

        let removeReport = DeleteMgrReportEndpoint(empId: String(mgrEmpId ?? 0), reportId: reportId)
        removeReport.apiCall { [self] (error)  in

            if (error?.success ?? false) == false {
                NavigationController.shared?.showErrorView(error: error)
            } else {
                if !monthReportsEmp {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editMonthReporEmp"), object: nil)
                }
            }
        }
    }

    func addMgrReport() {
        guard let date = getDateForReport() else { return }

        let addReport = AddMgrReporEndpoint(empId: String(mgrEmpId ?? 0), type: mgrType,
                                            date: date.toString(format: "yyyy-MM-dd HH:mm:ss"))
        addReport.apiCall { [self] (error) in

            if (error?.success ?? false) == false {
                NavigationController.shared?.showErrorView(error: error)
            } else {
                if !monthReportsEmp {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editMonthReporEmp"), object: nil)
                }
            }
        }
    }
    
    func shouldDIsableConfirmView() -> Bool {
        if isRevacha && CompaniesDataManager.shared.getReportCompletionNote() == 1  && (remark == "" || remark == nil){
            return true
        } else {
            return false
        }
    }
}
 
protocol EditReportViewModelDelegate: NSObjectProtocol {
    func didEditReport(_ empReports: [String: EmpDayReportsObj]?)
    func didRemoveReport(_ empReports: [String: EmpDayReportsObj]?)
    func didReceiveError(_ error: ErrorObject?)
}
