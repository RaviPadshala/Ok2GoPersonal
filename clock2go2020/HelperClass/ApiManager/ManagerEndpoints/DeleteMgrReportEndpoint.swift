//
//  DeleteMgrReport.swift
//  clock2go2020
//
//  Created by Gleb on 17.11.2020.
//

import Foundation
import Alamofire

class DeleteMgrReportEndpoint: EndpointItem {

    var empId: String?
    var reportId: Int?
    var remark: String?

    init(empId: String?, reportId: Int?) {
        self.empId = empId
        self.reportId = reportId
        self.remark = "refused !"

        super.init(endpointType: .deleteMgrReport)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        dict["token"]  = ManagerAppDataManager.shared.getManagerToken()
        dict["remark"] = remark

        if empId != nil {
            dict["empId"] = empId
        }

        if reportId != nil {
            dict["reportId"] = reportId
        }
        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }

    }

}
