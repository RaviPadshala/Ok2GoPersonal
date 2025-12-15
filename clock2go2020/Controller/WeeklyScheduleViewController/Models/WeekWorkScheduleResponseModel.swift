//
//  WeekWorkScheduleResponseModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 09.08.2022.
//

import UIKit

struct WeekWorkScheduleResponseModel: Codable {
    let success: Bool
    let data: [WeekWorkScheduleModel]
}
