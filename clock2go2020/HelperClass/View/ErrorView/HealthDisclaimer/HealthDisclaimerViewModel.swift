//
//  HealthDisclaimerViewModel.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/27/20.
//

import UIKit

enum HealthDisclaimerType {
    case disclaimer
    case accepted
    case rejected

    var title: String {
        switch self {
            case .disclaimer:
                return ""
            case .accepted:
                return "HEALTH_DISCLAIMER_APPROVED".localized
            case .rejected:
                return "HEALTH_DISCLAIMER_REJECTED".localized
        }
    }

    var image: UIImage? {
        switch self {
            case .disclaimer:
                return #imageLiteral(resourceName: "virus2")
            case .accepted:
                return #imageLiteral(resourceName: "success")
            case .rejected:
                return #imageLiteral(resourceName: "virus2")
        }
    }

    var color: UIColor? {
        switch self {
            case .disclaimer:
                return #colorLiteral(red: 0.2672953308, green: 0.860278666, blue: 0.5050097704, alpha: 1)
            case .accepted:
                return #colorLiteral(red: 0.9212146401, green: 0.9490351081, blue: 0.9671724439, alpha: 1)
            case .rejected:
                return #colorLiteral(red: 0.9619900584, green: 0.3149540126, blue: 0.3148945868, alpha: 1)
        }
    }
}

class HealthDisclaimerViewModel {
    var type: HealthDisclaimerType
    var disclaimerMessage: String?

    init(type: HealthDisclaimerType, message: String? = nil) {
        self.type = type
        self.disclaimerMessage = message
    }

    func getMessageTitle() -> String {
        return disclaimerMessage ?? type.title
    }

    func getImage() -> UIImage? {
        return type.image
    }

    func getColor() -> UIColor? {
        return type.color
    }

    func shouldShowConfirmView() -> Bool {
        switch type {
            case .disclaimer:
                return false
            case .accepted:
                return true
            case .rejected:
                return true
        }
    }

}
