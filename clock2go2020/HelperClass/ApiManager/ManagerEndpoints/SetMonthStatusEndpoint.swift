//
//  SetMonthStatusEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/9/20.
//

import Foundation
import Alamofire

class SetMonthStatusEndpoint: EndpointItem {

    var month: String?
    var status: Int?
    var empId: Int?
    var email: String?

    init(month: String, status: Int, empId: Int, email: String?) {
        self.month = month
        self.status = status
        self.empId = empId
        self.email = email
        super.init(endpointType: .setMonthStatus)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"]  = ManagerAppDataManager.shared.getManagerToken()
        dict["month"]  = month
        dict["status"] = status
        dict["empId"]  = empId
        dict["email"]  = email
        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }

    }

}
