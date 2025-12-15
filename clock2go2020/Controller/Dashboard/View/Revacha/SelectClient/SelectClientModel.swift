//
//  SelectClientModel.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 14.08.2020.
//

import Foundation

enum SelectClientType: Int {
    case treatment = 1
    case training = 2
    case generalTraining = 3
    case officeTreatment = 6
    case onSiteTreatment = 4
    case groupTreatment = 5
    
    func shouldDisableSelectClientView() -> Bool {
        switch self {
            case .generalTraining:
                return true
            default:
                return false
        }
    }
    
    func shouldDisableAdditionalButtons() -> Bool {
        switch self {
            case .generalTraining:
                return true
            default:
                return false
        }
    }
}
