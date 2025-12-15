//
//  DayWorkScheduleHeaderViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 05.08.2022.
//

import UIKit

class DayWorkScheduleHeaderViewModel {
    private(set) var timeString: String = "WORK_SCHEDULE_TIME_STRING".localized
    private(set) var taskNameString: String = "WORK_SCHEDULE_TASK_NAME_STRING".localized
    private(set) var addressString: String = "WORK_SCHEDULE_ADDRESS_STRING".localized
    private(set) var noteString: String = "WORK_SCHEDULE_NOTE_STRING".localized
    
    func reloadInfo() {
        timeString = "WORK_SCHEDULE_TIME_STRING".localized
        taskNameString = "WORK_SCHEDULE_TASK_NAME_STRING".localized
        addressString = "WORK_SCHEDULE_ADDRESS_STRING".localized
        noteString = "WORK_SCHEDULE_NOTE_STRING".localized
    }
}
