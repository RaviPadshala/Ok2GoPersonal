//
//  ReportActionType.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import Foundation

enum ReportActionType: String {
    case workStart            = "1"
    case workEnd              = "2"
    case dayOff               = ""
    case startTracking        = "70"
    case endTracking          = "71"
    case trackGeolocation     = "72"
    case breakStart           = "98"
    case breakEnd             = "99"
    case sampleReport         = "106"
    case serviceEntry         = "303"
    case serviceExit          = "304"
    case endAndStartWork      = "901"
    case returnFromService    = "3"
    case exitFromService      = "4"
    case FamilyAbsence        = "103"
}
