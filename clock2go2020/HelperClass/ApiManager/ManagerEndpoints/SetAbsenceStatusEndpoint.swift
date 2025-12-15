//
//  SetAbsenceStatus.swift
//  clock2go2020
//
//  Created by Gleb on 20.11.2020.
//

import Foundation
import Alamofire

class SetAbsenceStatusEndpoint: EndpointItem {
    var empId: String?
    var reportId: Int?
    var status: Int?

    init(empId: String?, reportId: Int?, status: Int?) {
        self.empId = empId
        self.reportId = reportId
        self.status = status

        super.init(endpointType: .setAbsenceStatus)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        dict["token"] = ManagerAppDataManager.shared.getManagerToken()

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
