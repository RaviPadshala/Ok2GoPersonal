//
//  TaskObj.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import UIKit

struct TaskObj: Codable {
    var taskId: String
    var taskName: String
    var projectId: Int?
    var projectName: String?
    var remark: String?
    var entitytype: String?
    var TherapyType: Int?
    var trnstypeid: Int?

    var hoursLimit: Double?
    var hoursCompleted: Double?
    var distanceSettings: MerkavaDistanceSettingType?

    var fromTime: String?
    var toTime: String?
}

enum MerkavaDistanceSettingType: Int, Codable {
    case noDistance = 0
    case onlyFromGPS = 1
    case allTypes = 2

    var shouldEnableAddRideView: Bool {
        switch self {
            case .noDistance:
                return false
            case .onlyFromGPS:
                return false
            case .allTypes:
                return true
        }
    }

    var shouldEnableRideView: Bool {
        switch self {
            case .noDistance:
                return false
            case .onlyFromGPS:
                return true
            case .allTypes:
                return true
        }
    }
}
