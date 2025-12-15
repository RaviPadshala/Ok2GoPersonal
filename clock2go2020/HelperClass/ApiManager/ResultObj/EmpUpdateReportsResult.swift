//
//  EmpUpdateReportsResult.swift
//  clock2go2020
//
//  Created by Admin on 3/30/20.
//

import UIKit

struct EmpUpdateReportsResult: Codable {

    var success: Bool?

    var data: [String: EmpDayReportsObj]?

}
