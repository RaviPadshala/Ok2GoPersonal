//
//  ApproveHourObj.swift
//  clock2go2020
//
//  Created by Mac on 18/03/24.
//

import Foundation


import Foundation

/*
 "approve_hours": {
 "hours_approved_id": 9,
 "month": 2,
 "year": 2024,
 "hours_approved": 20
}
*/
struct ApproveHourObj: Codable {
    var id: Int?
    var month: Int?
    var year: Int?
    var hoursApproved: Int?

    enum CodingKeys: String, CodingKey {
        case id = "hours_approved_id"
        case month = "month"
        case year = "year"
        case hoursApproved = "hours_approved"
    }
    
}
