//
//  WeeklyScheduleCellViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 09.08.2022.
//

import UIKit

class WeeklyScheduleCellViewModel {
    
    let addressString: String
    let timeString: String
    let dayString: String
    let taskNameString: String
    let taskCodeString: String
    let textColor: UIColor
    
    init(model: WeekWorkScheduleModel) {
        addressString = model.address ?? ""
        timeString = model.time ?? ""
        dayString = "\(model.day ?? 0)"
        taskNameString = model.taskname ?? ""
        taskCodeString = model.taskId ?? ""
        textColor = (Int(model.id ?? "0") ?? 0) > 0 ? UIColor(red: 244 / 255.0, green: 85 / 255.0, blue: 85 / 255.0, alpha: 1.0) : UIColor(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1.0)
    }
}
