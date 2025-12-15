//
//  ReminderDaysViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/11/20.
//

import UIKit


class FormViewModel {

   // var selectedDays: [Int]
    var formsData : [FormData]?

    init() {
        let formArr = CompaniesDataManager.shared.getFormsData()?.filter({$0.conditions!.showInMyForms! == 1})
        self.formsData = formArr
        //selectedDays = UserDefaultsManager.reminderDays ?? [1, 2, 3, 4, 5]
    }

   
    func getNumberOfRows() -> Int {
        
        return formsData?.count ?? 0
      //  return ReminderDaysType.allCases.count
    }

    func getModelFor(index: Int) -> FormCellViewModel {
//        let isSelected = isSelectedDay(index: index)
//        return FormCellViewModel(type: ReminderDaysType(rawValue: index)!, isSelected: isSelected)
        return FormCellViewModel(form: formsData?[index])
    }

    func getURL(index:Int)-> String?{
       // print("Entity type = \(formsData?[index].entityType) & TaskIdentity = \(formsData?[index].taskIdentity)")
        return formsData?[index].url
    }
    
    func getformName(index:Int)-> String?{
        return formsData?[index].formName
    }
//
    func getformMandatoryBeforeReport(index:Int)-> Bool?{
        
        return formsData?[index].conditions?.mandatoryBeforeReport == 1
    }
}
