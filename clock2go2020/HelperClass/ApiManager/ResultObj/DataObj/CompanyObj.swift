//
//  CompanyObj.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import UIKit

enum Tasks: Codable {
    case bool(Bool)
    case tasksArray([TaskObj?])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode([TaskObj?].self) {
            self = .tasksArray(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(Tasks.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Test"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .tasksArray(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}

struct CompanyObj: Codable {
    var nfc : String?                           /// is NFC Functionalty to app
    var nfcMandatory : Int?                     /// is NFC Functionalty is Mandatory
    var NFCReportAppAutomatically : Int?                     /// is NFC Functionalty is Mandatory
    var employeeId: Int?                        /// employee ID
    var employeeName: String?                   /// employee name
    var employeeEmail: String?                  /// employee email
    var clientId: Int?                          /// company ID
    var clientName: String?                     /// company name
    var clientGrpId: Int?                       /// client group ID
    var specialRules: Int?
    var todayWorkingTime: Int?                  /// total working time until now (in seconds)
    var activeBreakTime: Int?                   /// break time until now (in seconds)
    var monthlyStats: [String: MonthObj]?      /// monthly statistics
    var lastReports: [ReportObj?]?              /// all reports of the current day
    var standards: [StandartsObj?]?             /// standards working hours
    var taskList: Tasks                      /// list of available tasks
    var settings: SettingsObj?
    var showTrackingDisclaimer: Int?           /// 1 means the disclaimer for tracking must be shown
    var appPermission: Int?
    var addonButtons: AddonButtonsObj?
    var empsByDepartment: [DepartmentObj]?
    var employer: EmployerObj?
    var events: [RevachaEventObj]?
    var therapyevent_types: [TherapyeventTypesObj]?
    var citylist: [CitylistObj]?
    var isAbsentToday: Int?
    var dailyWorkSchedule: [WorkScheduleObj]?
    var locationNames: [LocationNameObj]?
    var formsdata :[FormData]?
    var datetimenow: DateObj?
    var datenow: String?
    var approveHours : ApproveHourObj?
    var dailyStudentReports : [String: [DailyStudentReportsObj]]?
    var Coordinator: Int?
    var applicationmustbeupdated: Int?
    var tasks: [TaskObj?]? {
        switch taskList {
        case .bool:
            return nil
        case .tasksArray(let array):
            return array
        case .null:
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case employeeId, employeeName, employeeEmail, clientId, clientName, clientGrpId, specialRules, todayWorkingTime, activeBreakTime, monthlyStats, lastReports, standards, settings, showTrackingDisclaimer, appPermission, addonButtons, empsByDepartment, employer, events, isAbsentToday, dailyWorkSchedule, locationNames,formsdata, datetimenow, datenow, dailyStudentReports, Coordinator, NFCReportAppAutomatically, citylist, therapyevent_types, applicationmustbeupdated
        case taskList = "tasks"
        case nfc = "NFC"
        case nfcMandatory = "NFCMANDATORY"
        case approveHours = "approve_hours"
    }
}
 
