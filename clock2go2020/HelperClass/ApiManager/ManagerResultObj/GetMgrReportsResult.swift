//
//  GetMgrReportsResult.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import AnyCodable

struct GetMgrReportsResult: Codable {

    var success: Bool?
    var data: [String: AnyCodable]?
}
