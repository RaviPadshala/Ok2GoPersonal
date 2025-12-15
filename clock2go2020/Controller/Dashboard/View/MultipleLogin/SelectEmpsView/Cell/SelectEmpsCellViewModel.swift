//
//  SelectEmpsCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 5/11/20.
//

import UIKit

class SelectEmpsCellViewModel {

    var item: EmployeeListItem
    var isSelected: Bool

    private let arrowExpanded = UIImage(named: "arrow_Up")
    private let arrowCollapsed = UIImage(named: "arrow_down")

    init(item: EmployeeListItem, isSelected: Bool) {
        self.item = item
        self.isSelected = isSelected
    }

    func getName() -> String {
        return item.employee.empName ?? ""
    }

    func getSelectImage() -> UIImage? {
        return isSelected ? UIImage(named: "checked_terms") : UIImage(named: "unchecked_terms")
    }

    func getBackgroundColor() -> UIColor? {
        return item.isRoot ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9231129289, green: 0.9492073655, blue: 0.9671584964, alpha: 1)
    }

    func getExpandedIcon() -> UIImage? {
        if item.descendants.count > 0 {
            if item.isRoot {
                return item.isExpanded
                    ? arrowExpanded
                    : arrowCollapsed
            }
        }

        return nil
    }

    func shouldHaveUsersButton() -> Bool {
        return item.descendants.count > 0
    }

    func shouldHaveUsersIndicatorView() -> Bool {
        return (item.descendants.count > 0 || !item.isRoot)
    }

}
