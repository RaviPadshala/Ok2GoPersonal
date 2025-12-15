//
//  GetExitEnforcementObj.swift
//  clock2go2020
//
//  Created by Gleb on 27.01.2021.
//

import Foundation

struct GetExitEnforcementObj: Codable {
    var startTime: String
    var frequency: Int
    var lat: Double?
    var lon: Double?
}
