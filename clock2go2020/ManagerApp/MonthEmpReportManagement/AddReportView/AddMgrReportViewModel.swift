//
//  AddMgrReportViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 17.12.2020.
//

import Foundation
import  UIKit
import Alamofire

class AddMgrReportViewModel {

    private var report: GetMgrEmpReportsObj
    private var date: Date?
    private var empId: String = ""

    let loadingView = LoadingView()

    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    init(report: GetMgrEmpReportsObj = GetMgrEmpReportsObj(), date: Date? = Date()) {
        self.report = report
        self.date = date
    }

    func getReport() -> GetMgrEmpReportsObj {
        return report
    }

    func getRemark() -> String {
        return report.remarkIn ?? ""
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

    func getTaskName() -> String {
        return report.taskName ?? "SELECT_TASK".localized
    }

    func shouldShowTaskFeature() -> Bool {
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
        return report.date ?? "Select date"
    }

    func getMinimumDateForReportUpdate() -> Date? {
        guard let date = self.date else { return nil }
        return date.startOfMonth()
    }

    func getMaximumDateForReportUpdate() -> Date? {
        guard let date = self.date else { return nil }
        return date.endOfMonth()
    }

    func shouldShowTaskError() -> Bool {
        if CompaniesDataManager.shared.shouldReportTask() && report.taskName == nil {
            return true
        }
        return false
    }

}
