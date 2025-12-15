//
//  DistanceConfirmViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/7/20.
//

import UIKit
import TSLocationManager

enum DistanceMeasurementType: Int {
    case startTracking  = 74
    case stopTracking   = 75
    case showTracked
}

class DistanceConfirmViewModel {
    var type: DistanceMeasurementType
    var hasLoginTitle: Bool

    init(type: DistanceMeasurementType, hasLoginTitle: Bool) {
        self.type = type
        self.hasLoginTitle = hasLoginTitle
    }

    func shouldShowLoginTitle() -> Bool {
        return hasLoginTitle
    }

    func getTrackingTitle() -> String {
        switch type {
            case .startTracking:
                return "START_TRAKING_TITLE".localized
            case .stopTracking:
                return "STOP_TRAKING_TITLE".localized
            case .showTracked:
               let distance = UserDefaultsManager.lastUserDistance
                print("\n\n\n\n\n\n\n\n\n\n \( String(describing: UserDefaultsManager.lastUserDistance)) \n\n\n\n\n\n\n\n\n\n\n")
                return "SHOW_TRAKING_TITLE".localized + "\(round(distance ?? 0.0))" + " " + "METERS".localized
        }
    }

    func getConfirmTitle() -> String {
        switch type {
            case .startTracking:
                return "START_TRAKING_CONFIRM_TITLE".localized
            case .stopTracking:
                return "STOP_TRAKING_CONFIRM_TITLE".localized
            case .showTracked:
                return "SHOW_TRAKING_CONFIRM_TITLE".localized
        }
    }

    func shouldHideCancelButton() -> Bool {
        return type == .showTracked
    }

    func shouldSendCloseAction() -> Bool {
        return type == .showTracked
    }
}
