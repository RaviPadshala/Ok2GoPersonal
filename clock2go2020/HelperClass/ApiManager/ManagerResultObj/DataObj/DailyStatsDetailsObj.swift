//
//  DailyStatsDetailsObj.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation

struct DailyStatsDetailsObj: Codable {
    var id: Int?
    var EmpName: String?
    var status: String?
    var timeIn: String?
    var timeOut: String?
    var deptIds: [String?]?
}
