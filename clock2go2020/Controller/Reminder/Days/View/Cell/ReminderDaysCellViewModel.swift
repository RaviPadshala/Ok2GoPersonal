//
//  ReminderDaysCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/22/20.
//

import UIKit

class ReminderDaysCellViewModel {

    var daysType: ReminderDaysType
    var isDaySelected: Bool

    init(type: ReminderDaysType, isSelected: Bool) {
        self.daysType = type
        self.isDaySelected = isSelected
    }

    func getTitle() -> String {
        return daysType.title
    }

    func getBackgroundColor() -> UIColor {
        return isDaySelected ? #colorLiteral(red: 0.1238274649, green: 0.3782030344, blue: 0.6281121969, alpha: 1) : #colorLiteral(red: 0.1525193453, green: 0.4428958893, blue: 0.7513256669, alpha: 1)
       // return  #colorLiteral(red: 0.1238274649, green: 0.3782030344, blue: 0.6281121969, alpha: 1)
    }

}
