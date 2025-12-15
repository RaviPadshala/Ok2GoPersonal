//
//  ApproveHourObj.swift
//  clock2go2020
//
//  Created by Mac on 18/03/24.
//

import Foundation

struct DailyStudentReportsObj: Codable {
    var CoordinatorName: String?
    var ProjectId: Int?
    var TransId: Int?
    var ProjectName: String = ""
    var TaskName: String = ""
    var datetoday: String?
    var studentsdata: [Studentsdata]?

    enum CodingKeys: String, CodingKey {
        case CoordinatorName, ProjectId, TransId, ProjectName, TaskName, datetoday, studentsdata
    }
    
}

struct Studentsdata: Codable {
    var RegistrationDate: String?
    var trnsInCoordinator: String?
    var studentname: String?
    var presenceConfirmation: Int?
    var TransId: Int?
    var trnsTime: String?
    var scoreRYG: scoreRYG?
    var comment: String?
    var WorkScheduleID: Int?
    var isUpdateRecrod: Bool?
    

    enum CodingKeys: String, CodingKey {
        case studentname, presenceConfirmation, TransId, trnsTime, scoreRYG, comment, WorkScheduleID, RegistrationDate, trnsInCoordinator
    }
    
}

struct scoreRYG: Codable {
    var R: Int?
    var Y: Int?
    var G: Int?

    enum CodingKeys: String, CodingKey {
        case R, Y, G
    }
    
}
