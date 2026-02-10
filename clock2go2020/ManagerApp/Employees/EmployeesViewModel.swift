//
//  EmployeesViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/11/20.
//

import UIKit

class EmployeesViewModel {

    private var filterType: EmployeesFilterType = .activeOnly

    private var employees: [EmployeesObj?] = []
    private var employeesDetails: MonthStatsDetailsObj?
    private var filteredEmployees: [EmployeesObj?] = []

    weak var delegate: EmployeesViewModelDelegate?

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    init() {
        loadEmployeesData()
        loadEmployeesDetailsData()
    }

    func setFilterType(title: String) {
        guard let filter = EmployeesFilterType.withTitle(title) else { return }
        filterType = filter
        filterEmployees()
        delegate?.shouldReloadView()
    }

    func setEmployees(employees: [EmployeesObj?]) {
        self.employees = employees
        filterEmployees()
    }

    func setEmployyesDetails(empDetails: MonthStatsDetailsObj?) {
        self.employeesDetails = empDetails
    }

    func filterEmployees() {
        switch filterType {
            case .byEmployeeCode:
                filteredEmployees = getFilteredByCodeEmployees()
            case .notActiveOnly:
                filteredEmployees = getNotAtiveEmployees()
            case .activeOnly:
                filteredEmployees = getActiveEmployees()
            case .allEmployees:
                filteredEmployees = employees
        }
    }

    func getActiveEmployees() -> [EmployeesObj?] {
        return employees.filter {$0?.active == "1"}
    }

    func getNotAtiveEmployees() -> [EmployeesObj?] {
        return employees.filter {$0?.active == "0"}
    }

    func getFilteredByCodeEmployees() -> [EmployeesObj?] {
        return employees.sorted(by: {(Int($0?.empCode ?? "0") ?? 0) < (Int($1?.empCode ?? "0") ?? 0)})
    }

    func getFilterTitle() -> String {
        return filterType.title
    }

    func getNumberOfRows() -> Int {
        return filteredEmployees.count
    }

    func getModelForCellAt(indexPath: IndexPath) -> EmployeeCellViewModel? {
        guard var employee = filteredEmployees[indexPath.row] else { return nil }

        if let empId = employee.empId {
            if let absences = employeesDetails?.monthlyAbsencesDetails.first(where: {$0?.id == empId})??.absences {
                employee.absences = absences
            }

            if let hours = employeesDetails?.monthlyWorkedHoursDetails.first(where: {$0?.id == empId})??.hours {
                employee.workingHours = hours
            }
        }

        return EmployeeCellViewModel(employeeObj: employee)
    }

    func getModelForChooseFilterTypeView() -> ChooseListViewModel {
        let title = "FILTER_OPTIONS".localized
        let data = EmployeesFilterType.allTitles()
        return ChooseListViewModel(title: title, data: data)
    }

    // api
    func loadEmployeesData() {
        vc?.view.addSubview(loadingView)

        let empsEndpoint = EmployeesEndpoint()
        empsEndpoint.apiCall { result, error in
            self.loadingView.removeFromSuperview()
            if error?.success ?? false {
                self.setEmployees(employees: result ?? [])
                self.loadEmployeesDetailsData()
            } else {
            }
        }
    }

    func loadEmployeesDetailsData() {
        let empsDetailsEndpoint = MonthlyStatsDetailsEndpoint(month: Date().toString(format: "yyyy-MM"))
        empsDetailsEndpoint.apiCall { result, error in

            if error?.success ?? false {
                self.setEmployyesDetails(empDetails: result)
                self.delegate?.shouldReloadView()
            } else {

            }
        }
    }

    func getEmployeesDetail(index: IndexPath) {
        guard let empId = filteredEmployees[index.row]?.empId else { return }
        vc?.view.addSubview(loadingView)

        let employeeEndpoint = EmployeeEndpoint(empId: empId)
        employeeEndpoint.apiCall { result, error in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                var employee = result ?? EmployeeObj()
                employee.empId = String(empId)
                self.delegate?.shouldShowEditView(employee)
            } else {

            }
        }
    }

    func addEmployee(employee: EmployeeObj) {
        vc?.view.addSubview(loadingView)

        let addEmpEndpoint = AddEmployeeEndpoint(employee: employee)
        addEmpEndpoint.apiCall { result, error in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                self.setEmployees(employees: result ?? [])
                self.delegate?.shouldReloadView()
                NavigationController.shared?.showSuccessView(message: "EMPLOYEE_ADDED".localized)
            } else {
                self.showErrorView(message: error?.error_message, errorCode: error?.error_code)
            }
        }
    }

    func editEmployee(employee: EmployeeObj) {
        vc?.view.addSubview(loadingView)

        let editEmpEmployee = UpdateEmployeeEndpoint(employee: employee)
        editEmpEmployee.apiCall { result, error in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                self.setEmployees(employees: result ?? [])
                self.delegate?.shouldReloadView()
                NavigationController.shared?.showSuccessView(message: "EMPLOYEE_UPDATE".localized)
            } else {

            }
        }
    }
    
    func showErrorView(message: String?, errorCode: Int?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: String(errorCode ?? 0), message: message)
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
}

protocol EmployeesViewModelDelegate: NSObjectProtocol {
    func shouldReloadView()
    func shouldShowEditView(_ employee: EmployeeObj?)
    func shouldShowConfirmView()
}
