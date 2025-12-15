//
//  UpdateReportConfirmViewModel.swift
//  clock2go2020
//
//  Created by Admin on 3/23/20.
//

import Foundation
import UIKit

class UpdateReportConfirmViewModel {
    
    private var report: EmpDayReportsObj
    private var date: Date?
    
    var selectedDate: Date?
    let loadingView = LoadingView()
    
    var isRevacha: Bool {
        return CompaniesDataManager.shared.isRevacha()
    }
    
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    
    init(report: EmpDayReportsObj = EmpDayReportsObj(), date: Date? = Date()) {
        self.report = report
        self.date = date
    }
    
    func getReport() -> EmpDayReportsObj {
        return report
    }
    
    func getRemark() -> String {
        return report.remarkIn ?? ""
    }
    
    func shouldAddRemarkLabelHidden() -> Bool {
        //        return CompaniesDataManager.shared.getReportCompletionNote() != 1
        //        return (report.remarkIn ?? "").count > 0 || report.eventType != "-1"
        return CompaniesDataManager.shared.getReportCompletionNote() != 1 || report.eventType != "-1"
    }
    
    func getEventType() -> String? {
        return report.eventType
    }
    
    func setRemark(remark: String?) {
        report.remarkIn = remark
    }
    
    func setLogoutTime(time: String) {
        report.timeOut = time
    }
    
    func getLogoutTime() -> String {
        return report.timeOut ?? "--:--"
    }
    
    func setTask(task: TaskObj?) {
        report.taskName = task?.taskName
    }
    
    func setEvent(_ event: RevachaEventObj?) {
        report.eventType = event?.eventType
        if report.extraFields == nil {
            report.extraFields = [:]
        }
        if let eventType = event?.eventType {
            report.extraFields?["EventType"] = Int(eventType)
        }
    }
    
    func getTaskName() -> String {
        return report.taskName ?? "SELECT_TASK".localized
    }
    
    func shouldShowTaskFeature() -> Bool {
        if isRevacha {
            return !isRevacha
        }
        return CompaniesDataManager.shared.hasChooseTaskFeature()
    }
    
    func setLoginTime(time: String) {
        report.timeIn = time
    }
    
    func getLoginTime() -> String {
        return report.timeIn ?? "--:--"
    }
    
    func setDate(date: String) {
        report.date = date
    }
    
    func getDate() -> String {
        return report.date ?? " ".localized
    }
    
    func getMinimumDateForReportUpdate() -> Date? {
        guard let date = self.date else { return nil }
        return date.startOfMonth()
    }
    
    func getMaximumDateForReportUpdate() -> Date? {
        guard let date = self.date else { return nil }
        return date.endOfMonth()
    }
    
    func setSelectedDate(date: Date) {
        selectedDate = date
    }
    
    func setTrnsType(_ index: Int) {
        report.trnsType = index
        if report.extraFields == nil {
            report.extraFields = [:]
        }
        report.extraFields?["trnsType"] = index
    }
    
    func setExtraFields(extraFields:[String: Int]?) {
        report.extraFields = extraFields
    }
    
    func shouldShowTaskError() -> Bool {
        if CompaniesDataManager.shared.shouldReportTask() && report.taskName == nil {
            return true
        }
        return false
    }
  

    func hasReportTimeIn() -> Bool{
        return !(report.timeIn == nil || report.timeIn == "--:--")
    }
    
    func hasReportTimeOut() -> Bool{
        return !(report.timeOut == nil || report.timeOut == "--:--")
    }
    
    func isRemarkEmpty() -> Bool {
        return report.remarkIn == nil || (report.remarkIn?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
    }
    func isRemarkNeeded() -> Bool{
        return CompaniesDataManager.shared.getReportCompletionNote() == 1 ? isRemarkEmpty() : false
    }
    func hasDateSelected() -> Bool{
        return !(report.date == nil || report.date ==  "SELECT_DATE".localized)
    }
    
    func hasReportTaskName() -> Bool{
        if shouldShowTaskError(){
            return !(report.taskName == nil || report.taskName == "SELECT_TASK".localized)
        }else{
            return true
        }
       
    }
    
    func shouldDIsableConfirmView() -> Bool {
        if isRevacha {
            if report.trnsType == 3 {
                return !( report.trnsType != nil && (hasReportTimeIn() || hasReportTimeOut()) && !isRemarkNeeded() && hasDateSelected())
            }else{
                return !(hasReportTaskName() && report.trnsType != nil && (hasReportTimeIn() || hasReportTimeOut()) && !isRemarkNeeded() && hasDateSelected())
            }
            
        }else if shouldShowTaskFeature()
        {
            return !(hasReportTaskName() && (hasReportTimeIn() || hasReportTimeOut()) && !isRemarkNeeded() && hasDateSelected())
        }else if !shouldShowTaskFeature(){
            return !(hasReportTaskName() && (hasReportTimeIn() || hasReportTimeOut()) && !isRemarkNeeded() && hasDateSelected())
        }
        return true
    }
    
    
    //    func shouldDIsableConfirmView() -> Bool {
    //        if (isRevacha && CompaniesDataManager.shared.getReportCompletionNote() == 1){
    //            return true
    //        } else if isRevacha && ((report.eventType == "-1" && CompaniesDataManager.shared.getReportCompletionNote() == 1 ) || report.taskName == nil || report.trnsType == nil ) {
    ////        } else if isRevacha && ((report.eventType == "-1" && report.remarkIn?.count ?? 0 == 0) || report.taskName == nil || report.trnsType == nil) {
    //       // } else if isRevacha && (CompaniesDataManager.shared.getReportCompletionNote() == 1 || report.taskName == nil || report.trnsType == nil) {
    //            return true
    //        } else if shouldShowTaskFeature() {
    //            //return report.remarkIn == nil || (report.remarkIn?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
    //            return CompaniesDataManager.shared.getReportCompletionNote() == 1
    //        }
    //        return false
    //    }
    
    
    
    func shouldDisableEventClientViews() -> Bool {
        return report.trnsType == 3
    }
}

