//
//  AddMgrReport.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import Alamofire

class GetMgrReportEndpoint: EndpointItem {

    var empId: String?
    var type: Int?
    var date: String?

    init(empId: String, type: Int, date: String) {

        self.empId = empId
        self.type = type
        self.date = date

        super.init(endpointType: .addMgrReport)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["empId"] = empId
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
