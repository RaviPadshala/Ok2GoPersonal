//
//  GetDailyStatsDetailsResult.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation

struct DailyStatsDetailsResult: Codable {
    var success: Bool?
    var data: [DailyStatsDetailsObj?]
}
