//
//  AddMgrReport.swift
//  clock2go2020
//
//  Created by Gleb on 18.11.2020.
//

import Foundation
import Alamofire

class AddMgrReporEndpoint: EndpointItem {

    var empId: String?
    var type: Int?
    var date: String?

    init(empId: String?, type: Int?, date: String?) {
        self.empId = empId
        self.type  = type
        self.date  = date

        super.init(endpointType: .addMgrReport)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        dict["token"] = ManagerAppDataManager.shared.getManagerToken()

        if empId != nil {
            dict["empId"] = empId
        }

        if type != nil {
            dict["type"] = type
        }
        dict["date"] = date
        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }

    }

}
