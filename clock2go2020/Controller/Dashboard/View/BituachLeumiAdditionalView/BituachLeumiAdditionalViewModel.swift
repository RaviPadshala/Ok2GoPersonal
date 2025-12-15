//
//  BituachLeumiAdditionalViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 19.08.2022.
//

import UIKit

class BituachLeumiAdditionalViewModel {
    
    private static let redColor = UIColor(red: 244 / 255.0, green: 85 / 255.0, blue: 85 / 255.0, alpha: 1.0)
    private static let greenColor = UIColor(red: 68 / 255.0, green: 219 / 255.0, blue: 129 / 255.0, alpha: 1.0)
    
    private(set) var absenceString: String = ""
    private(set) var patientNotAtHomeString: String = ""
    private(set) var sampleReportString: String = ""
    private(set) var serviceExtitString: String = ""
    private(set) var serviceEntryString: String = ""
    private(set) var entryLabelColor: UIColor = BituachLeumiAdditionalViewModel.greenColor
    private(set) var entryButtonEnabled: Bool = true
    private(set) var exitLabelColor: UIColor = BituachLeumiAdditionalViewModel.redColor
    private(set) var exitButtonEnabled: Bool = true

    
    private var isLastReportLogin: Bool {
        guard let report = CompaniesDataManager.shared.getLastLoginReport() else { return false }
        
        if let task = report.taskName, task != "" {
            return true
        }
        
        return CompaniesDataManager.shared.shouldReportTask() || CompaniesDataManager.shared.mustReportPairs()
    }

    private var isLastReportServiceEntry: Bool {
        guard let report = CompaniesDataManager.shared.getLastLoginReport() else { return false }
        if report.taskName != "", report.actionType == ReportActionType.serviceEntry.rawValue {
            return true
        }
        
        return false
    }
    
    func shouldRefresh() {
        let additionalButtons = CompaniesDataManager.shared.getAddonButtons()
        
        absenceString = "ABSCENCE".localized
        serviceExtitString = (additionalButtons?.button_2?.text ?? "").localized
        serviceEntryString = (additionalButtons?.button_1?.text ?? "").localized
        sampleReportString = (additionalButtons?.button_3?.text ?? "").localized
        patientNotAtHomeString = (additionalButtons?.button_4?.text ?? "").localized
        
        if isLastReportServiceEntry {
            serviceReportStarted()
        } else if isLastReportLogin {
            regularReportStarted()
        } else {
            reportFinished()
        }
    }
    
    func showPatientNotAtHomeButton() -> Bool {
//        let additionalButtons = CompaniesDataManager.shared.getAddonButtons()
//        return (additionalButtons?.button_4?.disable ?? false)
        return CompaniesDataManager.shared.showPatientNotAtHome()
    }
    
    func disablePatientNotAtHomeButton() -> Bool {
        let additionalButtons = CompaniesDataManager.shared.getAddonButtons()
        return additionalButtons?.button_4?.disable ?? false
    }
    
    private func serviceReportStarted() {
        entryLabelColor = BituachLeumiAdditionalViewModel.greenColor
        exitLabelColor = BituachLeumiAdditionalViewModel.redColor
        entryButtonEnabled = true
        exitButtonEnabled = true
    }
    
    private func regularReportStarted() {
        entryLabelColor = BituachLeumiAdditionalViewModel.greenColor
        exitLabelColor = BituachLeumiAdditionalViewModel.redColor
        entryButtonEnabled = true
        exitButtonEnabled = true
    }
    
    private func reportFinished() {
        entryLabelColor = BituachLeumiAdditionalViewModel.greenColor
        exitLabelColor = BituachLeumiAdditionalViewModel.redColor
        entryButtonEnabled = true
        exitButtonEnabled = true
    }
}
