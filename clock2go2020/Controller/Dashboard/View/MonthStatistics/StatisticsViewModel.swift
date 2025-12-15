//
//  StatisticsViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/31/20.
//

import UIKit

class StatisticsViewModel {

    static let shared = StatisticsViewModel()

    var monthKeys: [String]? = []
    var monthValues: [MonthObj]? = []
    
    var cellViewModels: [StatistictCellViewModel] = []

    func refreshData() {
        if let months = CompaniesDataManager.shared.getMonthStatistics() {
            self.monthKeys = Array(months.keys)
            self.monthValues = Array(months.values)
        }
    }

    func getMonthStringAt(index: Int) -> String {
        return Calendar.getMonthLocalizedStringFor(index: index)
    }

    func getMonthIndexAt(index: Int) -> Int {
        let date = Calendar.current.date(byAdding: .month, value: -index, to: Date()) ?? Date()
        let month = Calendar.current.component(.month, from: date) - 1
        return month
    }

    func getMonthKeyIndexAt(monthIndex: Int) -> Int {
        let key = monthKeys?.first(where: {Int($0) == (monthIndex + 1)}) ?? ""
        return monthKeys?.firstIndex(of: key) ?? 0
    }

    func getModelForItemAt(index: Int) -> StatistictCellViewModel? {
        let monthIndex = getMonthIndexAt(index: index)
        let monthString = getMonthStringAt(index: monthIndex)

        let keyIndex = getMonthKeyIndexAt(monthIndex: monthIndex)
        let month = monthValues?[keyIndex]

        let isLast = monthValues?.count == index + 1
        let isFirst = index == 0

        return StatistictCellViewModel(month: month, monthString: monthString, isFirst: isFirst, isLast: isLast)
    }

    func getNumberOfCells() -> Int {
        return monthKeys?.count ?? 0
    }

    func selectMonthAt(index: Int) {
        let monthIndex = getMonthIndexAt(index: index)
        let date       = getDateForMonthIndex(index: monthIndex)

        let vc = ViewSource.reportManagementScreen()
        vc.config(model: ReportManagementViewModel(date: date))
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    func getDateForMonthIndex(index: Int) -> Date {
        guard var selectedDate = Calendar.current.date(bySetting: .month, value: index + 1, of: Date()) else { return Date() }

        if Date().months(from: selectedDate) < 0 {
            selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? Date()
        }

        return selectedDate
    }
}
