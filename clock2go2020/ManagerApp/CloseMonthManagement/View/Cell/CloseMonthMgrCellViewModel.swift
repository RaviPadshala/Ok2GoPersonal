//
//  CloseMonthMgrCellViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 30.09.2020.
//

import Foundation
import UIKit

class CloseMonthMgrCellViewModel {

    // MARK: - Private var
    private var isSelected: Bool
    private var filterType: SortingStatusMonth

    // MARK: - Public var
    let  employee: GetMonthSummaryObj

    init(employee: GetMonthSummaryObj, isSelected: Bool, filterType: SortingStatusMonth) {
        self.employee    = employee
        self.filterType  = filterType
        self.isSelected  = isSelected
    }

    // MARK: - Public func

     func getSelectedButtonImage() -> UIImage {
           return isSelected ? #imageLiteral(resourceName: "checked_terms") : #imageLiteral(resourceName: "unchecked_terms")
       }

    /// Get name  employee
    func getEmpName() -> String {
        return employee.empName ?? ""
    }

    /// Get total hours for employee
    func getTotalHours() -> String {
        return employee.totalTimeDecimal ?? "00:00"
    }

    /// Get num missing for employee
    func getMissing() -> Int {
        return employee.totalMissingReports ?? 0
    }

    /// Get num absence for employee
    func getAbsence() -> Int {
        return employee.totalAbsenseReports ?? 0
    }

    /// Get status for closed by emp
    func getMonthClosed() -> Int {
        return employee.monthClosed ?? 0
    }

    // Get MonthClosed Image for checkbox
    func getMonthClosedImage() -> UIImage? {
        if getMonthClosed() == 0 {
            return #imageLiteral(resourceName: "unchecked_terms")
        } else {
            return #imageLiteral(resourceName: "checked_terms")
        }
    }

    /// Get closeDate
    func getCloseDate() -> String {
        return employee.closedDate ?? "--"
    }

    /// Get shlomit Name
    func getShlomitName() -> String {
        return employee.employerName ?? "--"
    }

    /// Get shlomit  approval status
    func getEmployerApprovalStatus() -> Int {
        return employee.employerApproval ?? 0
    }

    /// Get shlomit approval string
    func getEmployerApproval() -> String {
        switch getEmployerApprovalStatus() {
        case 0:
            return "--"
        case 1:
            return "SIGNED".localized
        case 2:
            return "APPROVED".localized
        case 3:
            return "REJECTED".localized
        default:
            return "--"
        }
    }

    /// Get month Approved
    func getMgrApproved() -> Int {
        return employee.monthApproved ?? 0
    }

    /// Get shlomitApproval Image for checkbox
    func getMgrAppImage() -> UIImage? {
        if getMgrApproved() == 0 {
            return #imageLiteral(resourceName: "unchecked_terms")
        } else {
            return #imageLiteral(resourceName: "checked_terms")
        }
    }

    /// Get empId
    func getEmpId() -> Int {
        return employee.empId ?? 0
    }

    /// Get empCode
    func getEmpCode() -> String {
        return employee.empCode ?? ""
    }

    /// Get total work days emp
    func getTotalWorkDays() -> Int {
        return employee.totalWorkDays ?? 0
    }

    /// Get shlomit approval fate
    func getShlomitAppDate() -> String {
        return employee.employerApprovalDate ?? "--"
    }

}
