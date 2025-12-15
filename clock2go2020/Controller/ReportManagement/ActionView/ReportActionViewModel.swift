//
//  ReportActionViewModel.swift
//  clock2go2020
//
//  Created by Admin on 3/25/20.
//

import UIKit

class ReportActionViewModel {

    private var sortBy: SortingBy
    private var month: String
    var isClosed: Bool
    private var email: String

    private var hasMissingReports: Bool

    init(type: SortingBy = .allReports, month: String, isClosed: Bool, hasMissingReports: Bool) {
        self.sortBy = type
        self.month = month
        self.isClosed = isClosed
        self.email = ""
        self.hasMissingReports = hasMissingReports
    }

    // mgr sorting init
    init(type: SortingBy = .allReports, month: String, hasMissingReports: Bool) {
        self.sortBy = type
        self.month = month
        self.isClosed = true
        self.email = ""
        self.hasMissingReports = hasMissingReports
    }

    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"

        return formatter.date(from: month)
    }

    func getMonthString() -> String {
        guard let date = getDate() else { return "" }

        return Calendar.getMonthLocalizedStringBy(date: date)
    }

    func setMonthByIndex(_ index: Int) {
        let date = getDateForMonthIndex(index: index)
        month = date.toString(format: "yyyy-MM")
    }

    func getDateForMonthIndex(index: Int) -> Date {
        guard var selectedDate = Calendar.current.date(bySetting: .month, value: index + 1, of: Date()) else { return Date() }

        if Date().months(from: selectedDate) < 0 {
            selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? Date()
        }

        return selectedDate
    }

    func getSortTypeString() -> String {
        return sortBy.title
    }

    func setSortType(type: SortingBy) {
        sortBy = type
    }

    func shouldShowCloseMonthButton() -> Bool {
        return !isClosed && CompaniesDataManager.shared.hasCloseMonthFeature()
    }

    func shouldShowAbbButton() -> Bool {
//        return !isClosed && CompaniesDataManager.shared.hasReportCompletionFeature()
        return !isClosed && CompaniesDataManager.shared.hasReportAddFeature()
    }

    func shouldShowClosedMonthLabel() -> Bool {
        return isClosed
    }

    func setEmail(email: String) {
        self.email = email
    }

    func getModelForSendEmailView() -> EmailReportViewModel {
        return EmailReportViewModel(month: month, type: sortBy.type, email: email)
    }

    func getModelForSendMgrEmailView() -> EmailReportViewModel {
        return EmailReportViewModel(month: month, type: sortBy.type, email: email, isManager: true)
    }

    func getModelForCloseMonthView() -> CloseMonthViewModel? {
        guard let monthObj = getMonthObj(), let date = getDate() else { return nil }

        let monthString = getMonthString()
        return CloseMonthViewModel(date: date, monthObj: monthObj, monthString: monthString)
    }

    func getMonthObj() -> MonthObj? {
        guard let months = CompaniesDataManager.shared.getMonthStatistics() else { return nil }

        let monthKeys = Array(months.keys)
        let monthValues = Array(months.values)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        guard let date = formatter.date(from: month) else { return nil }
        let monthIndex = Calendar.current.component(.month, from: date)

        let key = monthKeys.first(where: {Int($0) == (monthIndex + 1)}) ?? ""
        let keyIndex = monthKeys.firstIndex(of: key) ?? 0

        return monthValues[keyIndex]
    }

    func shouldShowCloseMonthError() -> Bool {
        print(CompaniesDataManager.shared.shouldCompleteMonth() && self.hasMissingReports)

        return CompaniesDataManager.shared.shouldCompleteMonth() && self.hasMissingReports
    }

    func shouldEnableMonthView() -> Bool {
        return CompaniesDataManager.shared.getSpecialClientType() != 1
    }

    func shouldEnableSendEmail() -> Bool {
        if CompaniesDataManager.shared.getSpecialClientType() == 3665 {
            return true
        }
        return false
    }
}
