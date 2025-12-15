//
//  EmployeeCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/11/20.
//

import UIKit

class EmployeeCellViewModel {

    var employeeObj: EmployeesObj?

    init(employeeObj: EmployeesObj?) {
        self.employeeObj = employeeObj
    }

    func getEmployeeName() -> String {
        return employeeObj?.empName ?? ""
    }

    func getEmployeeAbsences() -> String {
        guard let absences = employeeObj?.absences else { return "-" }

        return String(describing: absences)
    }

    func getEmployeeWorkingHours() -> String {
        guard let workingHours = employeeObj?.workingHours else { return "-" }

        return String(describing: workingHours)
    }

    func getEmployeeStatusColor() -> UIColor {
        return (employeeObj?.active ?? "") == "1" ? #colorLiteral(red: 0.2443430722, green: 0.800511539, blue: 0.4006313086, alpha: 1) : #colorLiteral(red: 0.6731665134, green: 0.6732652783, blue: 0.673144877, alpha: 1)
    }

}
