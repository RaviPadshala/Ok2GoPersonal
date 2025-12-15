//
//  MonthStatsDetailsObj.swift
//  clock2go2020
//
//  Created by Admin on 4/14/20.
//

import UIKit

struct MonthStatsDetailsObj: Codable {
    var monthlyWorkedHoursDetails: [WorkedHoursDetailsObj?]
    var monthlyAbsencesDetails: [AbsencesDetailsObj?]
    var monthlyLacksDetails: [LacksDetailsObj?]
}

struct WorkedHoursDetailsObj: Codable {
    var id: Int?
    var EmpName: String?
    var hours: String?
}

struct AbsencesDetailsObj: Codable {
    var id: Int?
    var EmpName: String?
    var absences: Int?
}

struct LacksDetailsObj: Codable {
    var id: Int?
    var EmpName: String?
    var lacks: Int?
}
