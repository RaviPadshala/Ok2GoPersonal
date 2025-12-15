//
//  MonthEmpActionViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 19.01.2021.
//

import Foundation
import UIKit

class MonthEmpActionViewModel {
    // MARK: - Private property
    private var employeesList: [GetMonthSummaryObj] = []
    private var monthObj: MonthObj?
    private var monthStats: MonthStatsObj?

    // MARK: - Public property
    var month: String
    var monthTitle: String = ""
    let loadingView = LoadingView()
    var monthIndex: Int = 0

    // MARK: - Delegate
   weak var delegate: MonthEmpActionViewModelDelegate?

    // MARK: - Init CloseMonthMgr
    init(date: Date = Date()) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")

        if UserDefaultsManager.dateMgrReport != Date() {
            self.month = UserDefaultsManager.dateMgrReport.toString(format: "yyyy-MM")
        } else {
            self.month = date.toString(format: "yyyy-MM")
        }
      self.loadData()
    }

    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    init(monthIndex: Int) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")

        self.month = ""
        self.monthTitle = calendar.monthSymbols[monthIndex]

        let date = self.getDateForMonthIndex(index: monthIndex + 1)
        UserDefaultsManager.dateMgrReport = date
        self.month = date.toString(format: "yyyy-MM")
        self.monthObj = getMonthObj(monthIndex: monthIndex + 1)
    }

    func getMonthObj(monthIndex: Int) -> MonthObj? {
        if let months = CompaniesDataManager.shared.getMonthStatistics() {
            let monthKeys = Array(months.keys)
            let monthValues = Array(months.values)

            let key = monthKeys.first(where: {Int($0) == monthIndex}) ?? ""
            let keyIndex = monthKeys.firstIndex(of: key) ?? 0

            return monthValues[keyIndex]
        }
        return nil
    }

    func getMonthTitle() -> String {
        return monthTitle
    }

    func getDateForMonthIndex(index: Int) -> Date {
        guard var selectedDate = Calendar.current.date(bySetting: .month, value: index, of: Date()) else { return Date() }

        if Date().months(from: selectedDate) < 0 {
            selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? Date()
        }

        return selectedDate
    }

    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"

        return formatter.date(from: month)
    }

    func loadData() {
        let getEmpReports = GetMonthSummaryEndpoint(month: month, empId: UserDefaultsManager.empIdMgrReport)
        getEmpReports.apiCall { (result, error) in

            if error?.success ?? false {
                print("Get Manager  Cloth month Reports: success")
                self.setEmployees(result)
                print("RESULT: - \(String(describing: result))")
            } else {
                NavigationController.shared?.showErrorView(error: error)
                print("Get Manager Employee Reports: failed")
            }
        }
    }

    func setEmployees(_ employees: [GetMonthSummaryObj]) {
        employeesList = employees
        delegate?.didLoadData()
    }

    func  loadMonthStats() {
        let getMonthlyStats = MonthlyStatsEndpoint(month: month, empId: UserDefaultsManager.empIdMgrReport)
        getMonthlyStats.apiCall { (result, error) in
            if error?.success ?? false {
                self.setMonthlyStats(result)
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

    func setMonthlyStats(_ stats: MonthStatsObj?) {
        self.monthStats = stats
        delegate?.didLoadData()
    }

    func monthIsClosed() -> Bool {
        if employeesList.first?.monthClosed == 0 {
            return false
        }
        return true
    }

    func getStringMonthClose() -> String? {
        if monthIsClosed() {
            return "IS_CLOSE_MONTH_TITLE".localized
        }
        return "CLOSE_MONTH_TITLE".localized
    }

    func getMissing() -> Int? {
        return monthStats?.monthlyLacks ?? 0
    }

    func getAbsenceTitle() -> String? {
        return  String(monthStats?.monthlyAbsences ?? 0) + " " + "ABSENCES".localized
    }

    func getMissingTitle() -> String? {
        return String(monthStats?.monthlyLacks ?? 0) + " " + "MISSING".localized
    }

    func getHoursTitle() -> String? {
        return (monthStats?.monthlyWorkedHours ?? "00:00") + " " + "HOURS".localized
    }

    func getEmployerEmial() -> String? {
        return employeesList.first?.employerEmail ?? ""
    }
}

protocol MonthEmpActionViewModelDelegate: NSObjectProtocol {
    func didLoadData()
}
