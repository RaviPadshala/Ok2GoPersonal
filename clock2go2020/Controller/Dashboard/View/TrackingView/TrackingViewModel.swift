//
//  TrackingViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/24/20.
//

import UIKit

class TrackingViewModel {

    var isPaused: Bool {
        return CompaniesDataManager.shared.getLastBreakReport() != nil ? true : false
    }

    var isLastReportLogin: Bool {
      guard let report = CompaniesDataManager.shared.getLastLoginReport() else { return false }
        
        if let task = report.taskName, task != "" {
            return true
        }
        
        return CompaniesDataManager.shared.shouldReportTask() || CompaniesDataManager.shared.mustReportPairs()
    }
    
    var isLastReportServiceEntry: Bool {
        guard let report = CompaniesDataManager.shared.getLastLoginReport() else { return false }
        if report.taskName != "", report.actionType == ReportActionType.serviceEntry.rawValue {
            return true
        }
        
        return false
    }

    var isRevacha: Bool  {
        return CompaniesDataManager.shared.isRevacha()
    }
    
    var isBituachLeumiClient: Bool {
        return CompaniesDataManager.shared.isBituachLeumi()
    }
    
    var isTrackingStarted: Bool

    var distanceSettings: MerkavaDistanceSettingType?

    init(isTrackingStarted: Bool, distanceSettings: MerkavaDistanceSettingType? = nil) {
        self.isTrackingStarted = isTrackingStarted
        self.distanceSettings = distanceSettings
    }

    func getPauseTitle() -> String {
        if shouldDisplaySignedReportView() {
            return "דו״ח חתום"
        }
        return isPaused ? "END_PAUSE".localized : "PAUSE".localized
    }

    func getAlphaValueForAbsenceView() -> CGFloat {
        guard CompaniesDataManager.shared.hasAppPermission() else { return 0.5 }
        return isPaused ? 0.5 : 1
    }

    func getAlphaValueForPauseView() -> CGFloat {
        guard CompaniesDataManager.shared.hasAppPermission() else { return 0.5 }
        return 1
    }

    func getLoginViewBackgroundColor() -> UIColor {
        return shouldDisableLoginView() ? #colorLiteral(red: 0.7442518473, green: 0.9578620791, blue: 0.8526439071, alpha: 1) : #colorLiteral(red: 0.228403002, green: 0.8591639996, blue: 0.5058480501, alpha: 1)
    }

    func getLogoutViewBackgroundColor() -> UIColor {
        return shouldDisableLogoutView() ? #colorLiteral(red: 0.9830847383, green: 0.7999810576, blue: 0.8002194762, alpha: 1) : #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 1)
    }

    func shouldDisableTimerView() -> Bool {
        return (CompaniesDataManager.shared.getSpecialClientType() ?? 0) == 1 || (CompaniesDataManager.shared.getSpecialClientType() ?? 0) == 2 ? true : false
    }

    func shouldHideEventsView() -> Bool {
        return true//Events button near the Absence button
    }
    
    func shouldDisableLoginView() -> Bool {
//        if isRevacha && UserDefaultsManager.revachaLastLoginType != SelectClientType.generalTraining.rawValue || CompaniesDataManager.shared.isBituachLeumi()  {
//            return false
//        }
//        return (isPaused || isLastReportLogin || !CompaniesDataManager.shared.hasAppPermission()) && !CompaniesDataManager.shared.hasRequestExitCompletionFeature()
        let isRevachaCondition = isRevacha && UserDefaultsManager.revachaLastLoginType != SelectClientType.generalTraining.rawValue
        let isBituachLeumi = CompaniesDataManager.shared.isBituachLeumi()

        if isRevachaCondition || isBituachLeumi {
            return false
        }
        
        let isPausedCondition = isPaused
        let isLastReportLoginCondition = isLastReportLogin
        let noAppPermission = !CompaniesDataManager.shared.hasAppPermission()
        let hasRequestExitCompletion = CompaniesDataManager.shared.hasRequestExitCompletionFeature()
        
        return (isPausedCondition || isLastReportLoginCondition || noAppPermission) && !hasRequestExitCompletion
    }

    func shouldDisableLogoutView() -> Bool {
        if CompaniesDataManager.shared.isBituachLeumi() {
            return false
        }
        guard CompaniesDataManager.shared.hasAppPermission() else { return true }
        return isPaused
    }

    func shouldDisableAbsenceView() -> Bool {
        return isPaused || !CompaniesDataManager.shared.hasAppPermission()
    }

    func shouldDisableEventsView() -> Bool {
        return !CompaniesDataManager.shared.hasAppPermission()
    }
    
    func shouldDisablePauseView() -> Bool {
        return !CompaniesDataManager.shared.hasAppPermission()
    }

    func getPauseViewHeight() -> CGFloat {
        return (shouldDisplayBreakView() && shouldDisplayAbsenceView()) ? 65 : 80
    }

    func getPauseStackViewHeight() -> CGFloat {
        return (shouldDisplayBreakView() && shouldDisplayAbsenceView()) ? 40 : 30
    }
    
    func getImHereViewHeight() -> CGFloat {
        return (shouldDisplayImHereView() && shouldDisplayAbsenceView()) ? 65 : 80
    }

    func getImHereStackViewHeight() -> CGFloat {
        return (shouldDisplayImHereView() && shouldDisplayAbsenceView()) ? 40 : 30
    }

    func shouldDisplayTrackingView() -> Bool {
        return CompaniesDataManager.shared.hasDistanceMeasurementFeature()
    }

    func shouldShowAdditionalButtonsView() -> Bool {
        return CompaniesDataManager.shared.getAddonButtons() != nil && !isBituachLeumiClient
    }
    
    func additionalButtonsHeight() -> CGFloat {
        return shouldShowAdditionalButtonsView() ? 135.0 : 0.0
    }

    func shouldDisplaySignedReportView() -> Bool {
        return CompaniesDataManager.shared.getSpecialClientType() == 3665
    }

    func shouldDisplayBreakView() -> Bool {
        return CompaniesDataManager.shared.hasBreakFeature()
    }
    
    func shouldDisplayImHereView() -> Bool {
        return CompaniesDataManager.shared.hasImHereFeature()
    }

    func shouldDisplaySeparatorView() -> Bool {
        return shouldDisplayBreakView() && shouldDisplayAbsenceView()
    }

    func shouldDisplayAbsenceView() -> Bool {
        return CompaniesDataManager.shared.hasAbsenceFeature()
    }

    func shouldDisplayRoundPauseView() -> Bool {
        return (shouldDisplayAbsenceView() || shouldDisplayBreakView()) && !isBituachLeumiClient
    }

    func shouldEnableStartTrackingButton() -> Bool {
        guard CompaniesDataManager.shared.getSpecialClientType() == 3783 else { return !isTrackingStarted }
        return !isTrackingStarted && (distanceSettings?.shouldEnableRideView ?? false)
    }

    func shouldEnableStopTrackingButton() -> Bool {
        guard CompaniesDataManager.shared.getSpecialClientType() == 3783 else { return isTrackingStarted }
        return isTrackingStarted && (distanceSettings?.shouldEnableRideView ?? false)
    }

    func shouldDisplayStartTrackingImage() -> Bool {
        return isTrackingStarted
    }

    func shouldDisplayStandards() -> Bool {
        return CompaniesDataManager.shared.hadStandardWorkTime()
    }

    func getStandardStartTime() -> String {
        let startTime = CompaniesDataManager.shared.getStandardStartTime()

        return "- " + startTime.prefix(5) + " -"
    }

    func getStandardfinishTime() -> String {
        let finishTime = CompaniesDataManager.shared.getStandardFinishTime()

        return "- " + finishTime.prefix(5) + " -"
    }

    func shouldDisplayMultiReportView() -> Bool {
        return CompaniesDataManager.shared.hasMultiReportFeature() && !isBituachLeumiClient
    }
    
    func shouldHideBituachLeumiAdditionalView() -> Bool {
        return !isBituachLeumiClient
    }
}
