//
//  TaskBarItem.swift
//  clock2go2020
//
//  Created by Admin on 1/14/20.
//

import UIKit
import CoreLocation

class TaskBarItem {

    let task: ReportObj?

    var isActive: Bool = true

    var isSelected: Bool = false {
        didSet {
            isActive = isSelected
        }
    }

    init(task: ReportObj?) {
        self.task = task
    }

}
