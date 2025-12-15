//
//  DateObj.swift
//  clock2go2020
//
//  Created by Kamal Punia on 29/10/23.
//

import Foundation

/*"date": "2023-10-25 11:02:11.040442",
                "timezone_type": 3,
                "timezone": "Asia/Jerusalem"
*/
struct DateObj: Codable {
    var date: String?
    var timezoneType: Int?
    var timezone: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case timezoneType = "timezone_type"
        case timezone = "timezone"
    }
}
