//
//  MultiReportViewModel.swift
//  clock2go2020
//
//  Created by Admin on 5/11/20.
//

import UIKit

enum MultiReportType {
    case login
    case logout

    var color: UIColor? {
        switch self {
            case .login:
                return #colorLiteral(red: 0.228403002, green: 0.8591639996, blue: 0.5058480501, alpha: 1)
            case .logout:
                return #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 1)
        }
    }

    var reportType: ReportActionType {
        switch self {
            case .login:
                return .workStart
            case .logout:
                return .workEnd
        }
    }
}

struct MultipleReportObj {
    var type: MultiReportType
    var employees: [Int]
    var task: TaskObj?
    var remark: String
}

class MultiReportViewModel {

    var reportObj: MultipleReportObj

    init(type: MultiReportType) {
        self.reportObj = MultipleReportObj(type: type, employees: [], task: nil, remark: "")

        if type == .logout {
            self.reportObj.employees = UserDefaultsManager.multiLoginEmps ?? []

            let tasks = CompaniesDataManager.shared.getAvailableTasks()
            if let task = tasks.first(where: { $0?.taskId == UserDefaultsManager.multiLoginTask }) {
                self.reportObj.task = task
            }
        }
    }

    func getImageViewColor() -> UIColor? {
        return self.reportObj.type.color
    }

    func getChooseEmpsLabel() -> String {
        if self.reportObj.employees.count > 0 {
            if self.reportObj.employees.count == 1 {
                return "SELECTED_0_USER".localized.replacingOccurrences(of: "0", with: self.reportObj.employees.count.description)
            }
            return "SELECTED_0_USERS".localized.replacingOccurrences(of: "0", with: self.reportObj.employees.count.description)
        }

        return "SELECT_USERS_TO_PROCCED".localized
    }

    func getSelectedTaskLabel() -> String {
        if let name = self.reportObj.task?.taskName {
            return "Selected Task: " + name
        }

        return shouldReportTask() ? (reportObj.type == .login ? "CHOOSE_TASK_TO_LOGIN".localized : "CHOOSE_TASK_TO_LOGOUT".localized) : "TASK_NOT_CHOOSED".localized
    }

    func getReportObj() -> MultipleReportObj {
        return self.reportObj
    }

    func setChoosedEmployees(emps: [Int]) {
        self.reportObj.employees = emps
    }

    func getChoosedEmployees() -> [Int] {
        return self.reportObj.employees
    }

    func setTask(task: TaskObj?) {
       self.reportObj.task = task
    }

    func setRemark(remark: String?) {
        self.reportObj.remark = remark ?? ""
    }

    func getRemark() -> String {
        self.reportObj.remark
    }

    func shouldShowChooseTaskView() -> Bool {
        return CompaniesDataManager.shared.hasChooseTaskFeature()
    }

    func shouldReportTask() -> Bool {
        return CompaniesDataManager.shared.shouldReportTask()
    }

    func shouldEnableAproveView() -> Bool {
        return !(reportObj.employees.count == 0 || (shouldReportTask() && reportObj.task == nil))
    }

    func getSelectEmployeeModel() -> SelectEmpsViewModel {
        return SelectEmpsViewModel(emps: reportObj.employees)
    }
}
