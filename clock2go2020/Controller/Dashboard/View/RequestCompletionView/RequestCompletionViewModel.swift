//
//  RequestCompletionViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 16.09.2022.
//

import UIKit

protocol RequestCompletionViewModelDelegate: AnyObject {
    func shouldRefreshView()
}

final class RequestCompletionViewModel {
    private let model: LastEntryObj?
    private let lastEntryDate: Date?
    private let lastReport: ReportObj
    private var completionDate: Date?
    private var note: String = ""
    
    private(set) var successLoginString: String = ""
    private(set) var completionHeaderString: String = ""
    private(set) var completionAdditionalString: String = ""
    private(set) var timeString: String = ""
    private(set) var timeErrorString: String = ""
    private(set) var notePlaceholderString: String = ""
    private(set) var noteErrorString: String = "MUST_NOTE".localized
    private(set) var confirmButtonTitle: String = ""
    private(set) var cancelButtonTitle: String = ""
    
    private(set) var confirmButtonOpacity: CGFloat = 0.5
    private(set) var confirmButtonEnabled: Bool = false
    
    weak var delegate:RequestCompletionViewModelDelegate?

    init(_ model: LastEntryObj?, lastReport: ReportObj) {
        self.model = model
        self.lastReport = lastReport
        
        successLoginString = "LOGIN_SUCCESS_TITLE".localized + " \(lastReport.taskName ?? "")"
        
        let dateString = (model?.date ?? "") + " " + (model?.time ?? "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let lastEntryDate = dateFormatter.date(from: dateString)
        self.lastEntryDate = lastEntryDate
        if Calendar.current.isDateInToday(lastEntryDate ?? Date()) {
            completionHeaderString = "REQUEST_COMPLETION_TODAY_REPORT".localized
            completionAdditionalString = "REQUEST_COMPLETION_TODAY_WAS".localized + (model?.time ?? "")
        } else {
            completionHeaderString = "REQUEST_COMPLETION_YESTERDAY_REPORT".localized
            completionAdditionalString = "REQUEST_COMPLETION_YESTERDAY_WAS".localized + (model?.time ?? "")
        }
        timeString = "--:--"
        confirmButtonTitle = "CONFIRM".localized
        cancelButtonTitle = "CANCEL".localized
    }
    
    func changeTime(_ date: Date?) {
        guard let date = date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeString = dateFormatter.string(from: date)
        prepareCompletionDate(date)
        checkConfirmButtonAvailability()
        delegate?.shouldRefreshView()
    }
    
    private func prepareCompletionDate(_ date: Date) {
        guard let lastEntryDate = lastEntryDate else { return }
        
        if Calendar.current.isDateInToday(lastEntryDate) {
            completionDate = date
        } else {
            if isTime(fromDate: date, biggerThan: lastEntryDate) {
                var dateComponents = DateComponents()
                dateComponents.day = -1
                completionDate = Calendar.current.date(byAdding: dateComponents, to: date)
            } else {
                completionDate = date
            }
        }
    }
    
    private func isTime(fromDate: Date, biggerThan anotherDate: Date) -> Bool {
        let firstComponents = Calendar.current.dateComponents([.hour, .minute], from: fromDate)
        let secondComponents = Calendar.current.dateComponents([.hour, .minute], from: anotherDate)
        let firstMinutes = (firstComponents.hour ?? 0) * 60 + (firstComponents.minute ?? 0)
        let secondMinutes = (secondComponents.hour ?? 0) * 60 + (secondComponents.minute ?? 0)
        return firstMinutes > secondMinutes
    }
    
    private func isValidCompletionDate() -> Bool {
        guard let lastEntryDate = lastEntryDate, let completionDate = completionDate else { return false }
        if completionDate < lastEntryDate {
            timeErrorString = "REQUEST_COMPLETION_WRONG_TIMME_ERROR".localized
            return false
        }
        let difference = completionDate.timeIntervalSince(lastEntryDate)
        if difference > 86400 /*seconds in day*/ {
            timeErrorString = "REQUEST_COMPLETION_24_HOURS_ERROR".localized
            return false
        }
        timeErrorString = ""
        return true
    }
    
    private func checkConfirmButtonAvailability() {
        if !isValidCompletionDate() {
            confirmButtonOpacity = 0.5
            confirmButtonEnabled = false
            return
        }
        if note.count == 0 {
            confirmButtonOpacity = 0.5
            confirmButtonEnabled = false
            return
        }
        confirmButtonOpacity = 1.0
        confirmButtonEnabled = true
    }
    
    func canChangeNote(_ text: String) -> Bool {
        guard text.count <= 30 else { return false }
        note = text
        noteErrorString = note.count == 0 ? "MUST_NOTE".localized : ""
        checkConfirmButtonAvailability()
        delegate?.shouldRefreshView()
        return true
    }
    
    func confirmAction(_ completion: @escaping (() -> ())) {
        let completionReport = UpdateEmpReportEndpoint(type: ReportActionType.workEnd.rawValue, date: completionDate?.toString(format: "yyyy-MM-dd HH:mm:ss"), reportId: nil, remark: note, taskId: model?.taskId, extraFields: nil)
        completionReport.apiCall { [weak self] (result, error) in
            self?.clearLastEntryData()
            completion()
        }
    }
    
    private func clearLastEntryData() {
        CompaniesDataManager.shared.disableRequestExitCompletion()
    }
}
