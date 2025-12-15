//
//  GetTasksObj.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation

struct GetTasksObj: Codable {

    var taskId: Int?
    var taskCode: String?
    var taskName: String?
    var projectId: Int?
    var projectName: String?
    var budgetHours: Int?
    var hourPrice: Int?
    var totalHours: String?
    var completionRate: Double?
    var totalPrice: Double?

}
