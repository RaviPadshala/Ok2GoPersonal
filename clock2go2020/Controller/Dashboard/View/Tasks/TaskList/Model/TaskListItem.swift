//
//  TaskItem.swift
//  clock2go2020
//
//  Created by Admin on 1/13/20.
//

import UIKit

class TaskListItem: Equatable, NSCopying {

    let task: TaskObj

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
    var descendants: [TaskListItem] = [] {
        didSet {
            flatDescendants = getDescendantsInFlatModel()
        }
    }

    /// List of menu item's descendants in flat form
    ///     (including items of expanded descendants).
    private(set) var flatDescendants: [TaskListItem] = []

    init(task: TaskObj, isRoot: Bool = false) {
        self.task = task
        self.isRoot = isRoot
    }

    init(task: TaskObj, backgroundColor: UIColor?, isRoot: Bool, isExpanded: Bool, descendants: [TaskListItem]) {
        self.task = task
        self.backgroundColor = backgroundColor
        self.isRoot = isRoot
        self.isExpanded = isExpanded
        self.descendants = descendants
    }

    func refresh() {
        flatDescendants = getDescendantsInFlatModel()
    }

    private func getDescendantsInFlatModel() -> [TaskListItem] {
        var items = [TaskListItem]()

        if !self.isRoot && self.isExpanded {
            items.append(self)
        }

        for child in descendants {
            items.append(child)
        }

        return items
    }

    static func == (lhs: TaskListItem, rhs: TaskListItem) -> Bool {
        return lhs.task.taskId == rhs.task.taskId
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = TaskListItem(task: task, backgroundColor: backgroundColor, isRoot: isRoot, isExpanded: isExpanded, descendants: descendants)
        return copy
    }

}
