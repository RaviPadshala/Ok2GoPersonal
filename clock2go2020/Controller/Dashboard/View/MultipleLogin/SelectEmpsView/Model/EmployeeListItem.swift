//
//  EmployeeListItem.swift
//  clock2go2020
//
//  Created by Admin on 5/12/20.
//

import UIKit

class EmployeeListItem: Equatable, NSCopying {

    let employee: EmployeeByDepartmentObj

    var backgroundColor: UIColor?

    let isRoot: Bool

    /// Flag indicating whether the menu is expanded.
    var isExpanded: Bool = false {
        didSet {
            if !isExpanded {
                descendants.forEach({ $0.isExpanded = false })
            }

            flatDescendants = getDescendantsInFlatModel()
        }
    }

    /// List of menu item's descendants if any.
    var descendants: [EmployeeListItem] = [] {
        didSet {
            flatDescendants = getDescendantsInFlatModel()
        }
    }

    /// List of menu item's descendants in flat form
    ///     (including items of expanded descendants).
    private(set) var flatDescendants: [EmployeeListItem] = []

    init(employee: EmployeeByDepartmentObj, isRoot: Bool = false) {
        self.employee = employee
        self.isRoot = isRoot
    }

    init(employee: EmployeeByDepartmentObj, backgroundColor: UIColor?, isRoot: Bool, isExpanded: Bool, descendants: [EmployeeListItem]) {
        self.employee = employee
        self.backgroundColor = backgroundColor
        self.isRoot = isRoot
        self.isExpanded = isExpanded
        self.descendants = descendants
    }

    func refresh() {
        flatDescendants = getDescendantsInFlatModel()
    }

    private func getDescendantsInFlatModel() -> [EmployeeListItem] {
        var items = [EmployeeListItem]()

        if !self.isRoot && self.isExpanded {
            items.append(self)
        }

        for child in descendants {
            items.append(child)
        }

        return items
    }

    static func == (lhs: EmployeeListItem, rhs: EmployeeListItem) -> Bool {
        return lhs.employee.empId == rhs.employee.empId
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = EmployeeListItem(employee: employee, backgroundColor: backgroundColor, isRoot: isRoot, isExpanded: isExpanded, descendants: descendants)
        return copy
    }
}
