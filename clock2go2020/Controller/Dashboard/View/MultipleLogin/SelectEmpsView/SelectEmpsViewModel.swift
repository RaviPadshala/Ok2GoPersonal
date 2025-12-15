//
//  SelectEmpsViewModel.swift
//  clock2go2020
//
//  Created by Admin on 5/12/20.
//

import UIKit

class SelectEmpsViewModel {
    /// Closure which is called when some section collapses automatically and
    ///     it is necessary to update UI accordingly.
    var sectionCollapsed: ((Int) -> Void)?

    /// task list hierarchy.
    private var employeeListItems: [EmployeeListItem] = []

    private var selectedEmployees: [Int] = []
    // filtered emps list
     private var filteredEmpsListItems: [EmployeeListItem]
     private var isFilterActivated: Bool = false
     private var isNextActivated: Bool = false

    init(emps: [Int] = []) {
        selectedEmployees = emps
        filteredEmpsListItems = []

        setupEmployeesList()
    }

    func getSelectedEmployees() -> [Int] {
        return selectedEmployees
    }

    func filterActivated() -> Bool {
      return isFilterActivated
  }
    func nextActivated() -> Bool {
        return isNextActivated
    }

    func setupEmployeesList() {
        isFilterActivated = false
        employeeListItems = []
        filteredEmpsListItems = []

        let departments = CompaniesDataManager.shared.getDepartments()

        for department in departments {
            let departmentItem = EmployeeListItem(employee: EmployeeByDepartmentObj(empId: department.departmentId, empName: department.departmentName), isRoot: true)
            departmentItem.descendants = []

            if let employees = department.employees {
                for employee in employees {
                    let item = EmployeeListItem(employee: employee, isRoot: false)
                    departmentItem.descendants.append(item)
                }
            }
            employeeListItems.append(departmentItem)
        }
    }

    func filterList(filterText: String) {
           isFilterActivated = true
           filteredEmpsListItems = []

        for empListItem in employeeListItems {
            guard let item = empListItem.copy() as? EmployeeListItem else { return }
            item.isExpanded = empListItem.isExpanded

            if (item.employee.empName?.lowercased().contains(filterText.lowercased()))! {
                filteredEmpsListItems.append(item)

            } else {
                let name = item.descendants.filter({($0.employee.empName!.lowercased().contains(filterText.lowercased()) )})
                if name.count > 0 {
                    item.descendants = name
                    item.isExpanded = true
                    filteredEmpsListItems.append(item)
            }

        }
    }
}

    func unfilterList() {
           // collapseItems()
       isFilterActivated = false
       filteredEmpsListItems = []
       }

    func getNumberOfSections() -> Int {
        return isFilterActivated ? filteredEmpsListItems.count : employeeListItems.count
    }

    func getNumberOfRows(section: Int) -> Int {
        let empListArray = isFilterActivated ? filteredEmpsListItems : employeeListItems

        if empListArray.indices.contains(section) {
            let item = empListArray[section]

            // Check if menu has descendant submenus and if it's expanded.
            if item.descendants.count > 0 && item.isExpanded {
                // Return number of descendant submenus + root menu item.
                return item.flatDescendants.count + 1
            } else {
                // Return only root menu item.
                return 1
            }
        } else {
            return 0
        }
    }

    func getNumberOfExpandedRows() -> Int {
         let empListArray = isFilterActivated ? filteredEmpsListItems : employeeListItems

        var row = empListArray.count

        for item in empListArray {
            if item.isExpanded {
                row += item.flatDescendants.count
            }
        }

        return row
    }

    func getModelForItemAt(section: Int, row: Int) -> SelectEmpsCellViewModel? {
        let empListArray = isFilterActivated ? filteredEmpsListItems : employeeListItems

        if empListArray.indices.contains(section) {
            let isSelected = getSelectionState(by: IndexPath(row: row, section: section))
            if row == 0 {
                let item = empListArray[section]
                return SelectEmpsCellViewModel(item: item, isSelected: isSelected)
            } else {
                if empListArray[section].flatDescendants.indices.contains(row - 1) {
                    let item = empListArray[section].flatDescendants[row - 1]
                    return SelectEmpsCellViewModel(item: item, isSelected: isSelected)
                }
            }
        }

        return nil
    }

    func isItemExpandable(section: Int, row: Int) -> Bool {
        let empListArray = isFilterActivated ? filteredEmpsListItems : employeeListItems

        if empListArray.indices.contains(section) {
            if row == 0 {
                return empListArray[section].descendants.count > 0
            }
        }

        return false
    }

    func toggleItem(section: Int, row: Int) {
        let empListArray = isFilterActivated ? filteredEmpsListItems : employeeListItems

        if empListArray.indices.contains(section) {
            if row == 0 {
                let item = empListArray[section]
                if item.descendants.count > 0 {
                    item.isExpanded = !item.isExpanded
                }
            }
        }
    }

    private func collapseItems() {
        for menuIndex in 0..<employeeListItems.count {
            let item = employeeListItems[menuIndex]
            if item.isExpanded {
                item.isExpanded = false
                sectionCollapsed?(menuIndex)
            }
        }
    }

    func getItem(by index: IndexPath) -> EmployeeListItem? {
        let empListArray = isFilterActivated ? filteredEmpsListItems : employeeListItems

        if empListArray.indices.contains(index.section) {
            if index.row == 0 {
                let item = empListArray[index.section]
                return item
            } else {
                if empListArray[index.section].flatDescendants.indices.contains(index.row - 1) {
                    let item = empListArray[index.section].flatDescendants[index.row - 1]
                    return item
                }
            }
        }

        return nil
    }

    func selectEmployee(by indexPath: IndexPath) {

        if indexPath.row == 0 {
            selectDepartment(by: indexPath)
            return
        }

        guard let item = getItem(by: indexPath), let empId = item.employee.empId else { return }

        if selectedEmployees.contains(empId), let index = selectedEmployees.firstIndex(of: empId) {
            selectedEmployees.remove(at: index)
             isNextActivated = false
        } else {
             isNextActivated = true
            selectedEmployees.append(empId)
        }
    }

    func selectDepartment(by indexPath: IndexPath) {

        let isSelected = getSelectionDepartmentState(by: indexPath)

        let department = employeeListItems[indexPath.section]
        for item in department.descendants {
            if let empId = item.employee.empId {
                if isSelected {
                    if selectedEmployees.contains(empId), let index = selectedEmployees.firstIndex(of: empId) {
                        selectedEmployees.remove(at: index)
                      isNextActivated = false
                    }
                } else {
                    isNextActivated = true
                    if !selectedEmployees.contains(obj: empId) {
                        selectedEmployees.append(empId)
                    }
                }
            }
        }
    }

    func getSelectionState(by index: IndexPath) -> Bool {
        if index.row == 0 {
            return getSelectionDepartmentState(by: index)
        }

        guard let item = getItem(by: index), let empId = item.employee.empId else { return false }

        return selectedEmployees.contains(empId)
    }

    func getSelectionDepartmentState(by index: IndexPath) -> Bool {
        let department = employeeListItems[index.section]

        for item in department.descendants {

            if let empId = item.employee.empId, !selectedEmployees.contains(empId) {
                return false
            }
        }
        return true
    }

    func getSelectionAllState() -> Bool {
        for department in employeeListItems {
            for item in department.descendants {
                if let empId = item.employee.empId, !selectedEmployees.contains(empId) {
                    return false
                }
            }
        }
        return true
    }

    func getSelectAllButtonImage() -> UIImage? {
        let isAllSelected = getSelectionAllState()
        return isAllSelected ? UIImage(named: "checked_terms") : UIImage(named: "unchecked_terms")
    }

    func selectAll() {
        let isAllSelected = getSelectionAllState()

        for department in employeeListItems {
            for item in department.descendants {
                if let empId = item.employee.empId {
                    if isAllSelected {
                        if selectedEmployees.contains(empId), let index = selectedEmployees.firstIndex(of: empId) {
                            selectedEmployees.remove(at: index)
                            isNextActivated = false
                        }
                    } else {
                        if !selectedEmployees.contains(obj: empId) {
                            selectedEmployees.append(empId)
                            isNextActivated = true
                        }
                    }
                }
            }
        }
    }

    let taskListCellHeight = 50
    let offset = 5

    func getTableViewHeight() -> CGFloat {
        return CGFloat(self.getNumberOfExpandedRows() * self.taskListCellHeight + self.offset)
    }
}
