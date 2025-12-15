//
//  SetReportStatusEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/9/20.
//

import Foundation
import Alamofire

class SetReportStatus: EndpointItem {

    var empId: String?
    var reportId: Int?
    var status: Int?
    var remark: String?

    init(empId: String, reportId: Int, status: Int, remark: String) {

        self.empId = empId
        self.reportId = reportId
        self.status = status
        self.remark = remark

        super.init(endpointType: .setReportStatus)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["empId"] = empId
        dict["reportId"] = reportId
        dict["status"] = status
        dict["remark"] = remark

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }

    }

}
