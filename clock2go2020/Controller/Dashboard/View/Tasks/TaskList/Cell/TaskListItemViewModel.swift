//
//  TaskListItemViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/13/20.
//

import UIKit

class TaskListItemViewModel {

    let item: TaskListItem

    private let arrowExpanded = UIImage(named: "arrow_Up")
    private let arrowCollapsed = UIImage(named: "arrow_down")

    init(item: TaskListItem) {
        self.item = item
    }

    func getTaskTitle() -> String {
        return item.task.taskName
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

    func shouldHaveSubtaskButton() -> Bool {
        return item.descendants.count > 0
    }

    func shouldHaveSubtaskIndicatorView() -> Bool {
        return (item.descendants.count > 0 || !item.isRoot)
    }

}
