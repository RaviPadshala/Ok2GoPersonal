//
//  TermsViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/9/20.
//

import UIKit

enum TermsType {
    case common
    case tracking(disclaimer: String?)

    var title: String {
        switch self {
            case .common:
                return "TERMS_TITLE".localized
            case .tracking:
                return "TRACKING_TERMS_TITLE".localized
        }
    }

    var message: String {
        switch self {
        case .common:
            return "TERMS_TEXT".localized
        case .tracking(let disclaimer):
            if let disclaimer = disclaimer {
                return disclaimer
            }else {
                return "TRACKING_TERMS_TEXT".localized
            }
        }
    }

    var shouldShowBackButton: Bool {
        switch self {
            case .common:
                return false
            case .tracking:
                return true
        }
    }
}

class TermsViewModel {
    private var type: TermsType

    init(type: TermsType) {
        self.type = type
    }

    func getTitle() -> String {
        return type.title
    }

    func getMessage() -> String {
        return type.message
    }

    func shouldHideBackButton() -> Bool {
        return type.shouldShowBackButton
    }
}
