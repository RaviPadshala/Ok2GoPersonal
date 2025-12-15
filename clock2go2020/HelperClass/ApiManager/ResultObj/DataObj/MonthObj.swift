//
//  MonthObj.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import UIKit

struct MonthStatisticObj: Codable {
    var months: [String: MonthObj]
}

struct MonthObj: Codable {
    var misses: Int?
    var vacations: Int?
    var workingHours: String?
}
