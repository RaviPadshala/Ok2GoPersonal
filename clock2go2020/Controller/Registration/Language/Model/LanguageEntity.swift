//
//  LanguageEntity.swift
//  clock2go2020
//
//  Created by Admin on 12/23/19.
//

import UIKit

enum LanguageEntity: Int, CaseIterable {

    case english
    case hebrew
    case russian
//    case spanish
//    case portuguese
    case arabic
    case bulgarian
    case Thai
    case hindi
    case chinese

    static func withIdentifier(_ label: String) -> LanguageEntity? {
        return self.allCases.first { "\($0.idetifier)" == label }
    }

    var idetifier: String {
        switch self {
            case .hebrew:
                return "he"
            case .english:
                return "en"
            case .russian:
                return "ru"
//            case .spanish:
//                return "es"
//            case .portuguese:
//                return "pt"
            case .arabic:
                return "ar"
        case .bulgarian:
            return "bg"
        case .Thai:
            return "th"
        case .hindi:
            return "hi"
        case .chinese:
            return "zh-Hans"
        }
    }

    var languageTitle: String {
        switch self {
            case .hebrew:
                return "עברית"
            case .english:
                return "English"
            case .russian:
                return "Pусский"
//            case .spanish:
//                return "Español"
//            case .portuguese:
//                return "Português"
            case .arabic:
                return "عربيه"
        case .bulgarian:
            return "български"
        case .Thai:
            return "แบบไทย"
        case .hindi:
            return "हिंदी"
        case .chinese:
            return "中国人"
        }
    }

    var languageImage: UIImage? {
        switch self {
            case .hebrew:
                return UIImage(named: "israel")
            case .english:
                return UIImage(named: "unitedKingdom")
            case .russian:
                return UIImage(named: "russia")
//            case .spanish:
//                return UIImage(named: "spain")
//            case .portuguese:
//                return UIImage(named: "brazil")
            case .arabic:
                return UIImage(named: "turkey")
        case .bulgarian:
            return UIImage(named: "Bulgaria")
        case .Thai:
            return UIImage(named: "Thailand")
        case .hindi:
            return UIImage(named: "India")
        case .chinese:
            return UIImage(named: "China")
        }
    }

}
