//
//  EmpMonthlyStatsResult.swift
//  clock2go2020
//
//  Created by Admin on 3/25/20.
//

import UIKit

struct EmpMonthlyStatsResult: Codable {
    var success: Bool?

    var data: [String: MonthObj]?
}
