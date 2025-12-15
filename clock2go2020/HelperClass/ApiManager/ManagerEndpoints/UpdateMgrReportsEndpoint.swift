//
//  UpdateMgrReportsEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/9/20.
//

import Foundation
import Alamofire

class UpdateMgrReportsEndpoint: EndpointItem {

    var empId: Int?
    var reportId: Int?
    var type: Int?
    var date: String?

    init(empId: Int, reportId: Int, type: Int, date: String ) {

        self.empId = empId
        self.reportId = reportId
        self.type = type
        self.date = date

        super.init(endpointType: .updateMgrReports)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["empId"] = empId
        dict["reportId"] = reportId
        dict["type"] = type
        dict["date"] = date

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }

    }
}
