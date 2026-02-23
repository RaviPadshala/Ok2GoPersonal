//
//  AddEmployeeViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/12/20.
//

import UIKit

class AddEmployeeViewModel {
    var employee: EmployeeObj
    var isEditMode: Bool

    var departments: [DepartmentsObj?] = []

    init(employee: EmployeeObj = EmployeeObj(), isEditMode: Bool = false) {
        self.employee = employee
        self.isEditMode = isEditMode
        self.departments = ManagerAppDataManager.shared.getDepartments()
    }

    func getIconImage() -> UIImage? {
        return isEditMode ? #imageLiteral(resourceName: "employees") : #imageLiteral(resourceName: "plus")
    }

    func getIconViewColor() -> UIColor? {
        return isEditMode ? #colorLiteral(red: 0.9231129289, green: 0.9492073655, blue: 0.9671584964, alpha: 1) : #colorLiteral(red: 0.2443430722, green: 0.800511539, blue: 0.4006313086, alpha: 1)
    }

    func getEditTitle() -> String {
        return isEditMode ? "EDIT_EMPLOYEE".localized : "ADD_EMPLOYEE".localized
    }

    func getEditConfirmTitle() -> String {
        return isEditMode ? "SAVE_EDIT".localized : "ADD".localized
    }

    func getEmployee() -> EmployeeObj {
        return employee
    }

    func getCode() -> String {
        return employee.empCode ?? ""
    }

    func setCode(_ code: String?) {
        employee.empCode = code
    }

    func getName() -> String {
        return employee.empName ?? ""
    }

    func setName(_ name: String?) {
        employee.empName = name
    }

    func getPhone() -> String {
        return employee.empPhone ?? ""
    }

    func setPhone(_ phone: String?) {
        employee.empPhone = phone
    }

    func getEmail() -> String {
        return employee.empEmail ?? ""
    }
    
    func getDeptIds() -> [String?] {
        return employee.deptIds ?? []
    }
    
    func checkReportwayAddOrNot() -> Bool {
        if let val = employee.reportWay, val > 0{
            return true
        }
        return false
    }

    func setEmail(_ email: String?) {
        employee.empEmail = email
    }
    
    func clearAllField(){
        self.employee.empCode = nil
        self.employee.empName = nil
        self.employee.empPhone = nil
        self.employee.empEmail = nil
        self.employee.deptIds = nil
        self.employee.reportWay = nil
    }

    func getDepartmentTitles() -> [String] {
        return ManagerAppDataManager.shared.getDepartmentTitles()
    }

    func getSelectedDepartmentsTitles() -> [String] {
        var titles: [String] = []

        for depId in employee.deptIds ?? [] {
            if let department = departments.first(where: {$0?.empGrpId == Int(depId ?? "")}), let title = department?.empGrpName {
                titles.append(title)
            }
        }

        return titles
    }

    func setSelectedDepartments(selectedDepartments: [String]) {
        var deps: [String] = []

        for departmentName in selectedDepartments {
            if let department = departments.first(where: {$0?.empGrpName == departmentName}), let depId = department?.empGrpId {
                deps.append(String(depId))
            }
        }

        employee.deptIds = deps
    }

    func getReportWay() -> String {
        guard let reportWay = ReportWayType(rawValue: employee.reportWay ?? -1) else { return "REPORT_WAY_TITLE".localized }

        return reportWay.title
    }

    func setReportWay(title: String) {
        guard let reportWay = ReportWayType.withTitle(title) else { return }
//        if reportWay.rawValue == 3{
//            employee.reportWay = 4
//        }
        employee.reportWay = reportWay.rawValue
    }

    func isEnableTextField() -> Bool {
        if CompaniesDataManager.shared.getSpecialClientType() != 3665 {
            return false
        }
        return true
    }
}
