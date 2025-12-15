//
//  ReportObj.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import UIKit

struct ReportObj: Codable {
    var time: String
    var actionType: String?
    var location: String?
    var lon: String?
    var lat: String?
    var taskName: String?
    var taskId: String?
    var remark: String?
    var healthDisclaimerAccepted: Int?
    var event: String?
    
    var isInProgress: Bool {
        return self.actionType == ReportActionType.workStart.rawValue
    }
    
    var isCompleted: Bool {
        return self.actionType == ReportActionType.workEnd.rawValue
    }
}
