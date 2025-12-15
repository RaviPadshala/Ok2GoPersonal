//
//  FormCellViewModel.swift
//  clock2go2020
//
//  Created by Mac on 26/09/24.
//

import Foundation
import UIKit


class FormCellViewModel {

   // var daysType: ReminderDaysType
    //var isDaySelected: Bool
    var formData : FormData?

    init(form : FormData?) {
        self.formData = form
//        self.daysType = type
//        self.isDaySelected = isSelected
    }

    func getTitle() -> String {
       
        return formData?.formName ?? ""
    }

    func getBackgroundColor() -> UIColor {
        return #colorLiteral(red: 0.1238274649, green: 0.3782030344, blue: 0.6281121969, alpha: 1)
        //return isDaySelected ? #colorLiteral(red: 0.1238274649, green: 0.3782030344, blue: 0.6281121969, alpha: 1) : #colorLiteral(red: 0.1525193453, green: 0.4428958893, blue: 0.7513256669, alpha: 1)
       // return  #colorLiteral(red: 0.1238274649, green: 0.3782030344, blue: 0.6281121969, alpha: 1)
    }

}
