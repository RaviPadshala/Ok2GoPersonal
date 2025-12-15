//
//  DayWorkScheduleCellViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 05.08.2022.
//

import UIKit

class DayWorkScheduleCellViewModel {
    
    let addressString: String
    let taskNameString: String
    let timeString: String
    let noteString: String
    
    init(model: WorkScheduleObj) {
        addressString = model.address ?? ""
        taskNameString = model.task ?? ""
        timeString = model.time ?? ""
        noteString = model.note ?? ""
    }
}
