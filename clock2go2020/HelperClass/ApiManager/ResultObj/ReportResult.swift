//
//  ReportResult.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import UIKit

struct ReportResult: Codable {

    var success: Bool?

    var data: [ReportObj?]

}

struct CheckNFCResult: Codable {

    var success: Bool?

    var data: CheckNFCObj?

}

struct CheckNFCObj: Codable {
    var id: Int?
    var clientid: Int?
    var serial: String?
    var entitytype: Int?
    var entityid: String?
    var taskid: String?
    var NFCReportAppAutomaticallyTask: Int?
    var NFCReportAppWithTask: Int?
    var NFCReportAppTaskMundatory: Int?
    var NFCLocationVerificationAppButton: Int?
    var location: String?
    var active: Int?
    var with_interval: Int?
    var interval: Int?
}
