//
//  AbsenceTypeEntity.swift
//  clock2go2020
//
//  Created by Admin on 2/9/20.
//

import UIKit

enum AbsenceTypeEntity: String, CaseIterable {

    case vacation         = "5"
    case reserveService   = "6"
    case disease          = "7"
    case course           = "8"
    case generalAbsence   = "9"
    case kidDisease       = "10"
    case mourning         = "43"
    case electionsDay     = "44"
    case training         = "45"
    case maternity        = "46"
    case emergency        = "47"
    case wedding          = "48"
    case accident         = "49"
    case womensDay        = "60"
    case hmoVisit         = "61"
    case companyTrip      = "62"
    case declarationDay   = "63"
    case optionalHoliday  = "64"
    case spouseDisease    = "65"
    case parentDisease    = "66"
    case meetings         = "67"
    case unpaidVocation   = "68"
    case signedReport     = "92"
    case halfDayVocation  = "95"
    case coronaQuarantine = "97"
    case pairing          = "101"
    case available        = "102"
    case familyAbsence    = "103"

    static func withIdentifier(_ type: Int) -> AbsenceTypeEntity? {
        return self.allCases.first { $0.idetifier == type }
    }

    static func withTitle(_ title: String) -> AbsenceTypeEntity? {
        return self.allCases.first { $0.absenceTitle == title }
    }

    var idetifier: Int {
        switch self {
        case .vacation:
            return 5
        case .reserveService:
            return 6
        case .disease:
            return 7
        case .course:
            return 8
        case .generalAbsence:
            return 9
        case .kidDisease:
            return 10
        case .mourning:
            return 43
        case .electionsDay:
            return 44
        case .training:
            return 45
        case .maternity:
            return 46
        case .emergency:
            return 47
        case .wedding:
            return 48
        case .accident:
            return 49
        case .womensDay:
            return 60
        case .hmoVisit:
            return 61
        case .companyTrip:
            return 62
        case .declarationDay:
            return 63
        case .optionalHoliday:
            return 64
        case .spouseDisease:
            return 65
        case .parentDisease:
            return 66
        case .meetings:
            return 67
        case .unpaidVocation:
            return 68
        case .signedReport:
            return 92
        case .halfDayVocation:
            return 95
        case .coronaQuarantine:
            return 97
        case .pairing:
            return 101
        case .available:
            return 102
        case .familyAbsence:
            return 103
        }
    }

    var absenceTitle: String {
        switch self {
        case .vacation:
            return "VACATIONS".localized
        case .reserveService:
            return "RESERVE_SERVICE".localized
        case .disease:
            return "DISEASE".localized
        case .course:
            return "COURSE".localized
        case .generalAbsence:
            return "GENERAL_ABSENCE".localized
        case .kidDisease:
            return "KID_DISEASE".localized
        case .mourning:
            return "MOURNING".localized
        case .electionsDay:
            return "ELECTIONS_DAY".localized
        case .training:
            return "TRAINING".localized
        case .maternity:
            return "MATERNITY".localized
        case .emergency:
            return "EMERGENCY".localized
        case .wedding:
            return "WEDDING".localized
        case .accident:
            return "ACCIDENT".localized
        case .womensDay:
            return "WOMENS_DAY".localized
        case .hmoVisit:
            return "HMO_VISIT".localized
        case .companyTrip:
            return "COMPANY_TRIP".localized
        case .declarationDay:
            return "DECLARATION_DAY".localized
        case .optionalHoliday:
            return "OPTIONAL_HOLIDAY".localized
        case .spouseDisease:
            return "SPOUSE_DISEASE".localized
        case .parentDisease:
            return "PARENT_DISEASE".localized
        case .meetings:
            return "MEETINGS".localized
        case .unpaidVocation:
            return "UNPAID_VOCATION".localized
        case .halfDayVocation:
            return "HALF_DAY_VOCATION".localized
        case .coronaQuarantine:
            return "CORONA_QUARANTINE".localized
        case .pairing:
            return "PAIRING".localized
        case .available:
            return "AVAILABLE".localized
        case .signedReport:
            return "MONTH_REPORT".localized
        case .familyAbsence:
            return "FAMILY_ABSENCE".localized
        }
    }
}
