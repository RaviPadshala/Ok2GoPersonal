//
//  EmployeesEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import Alamofire

class EmployeesEndpoint: EndpointItem {

    init() {
        super.init(endpointType: .getEmployees)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()

        return dict
    }

    func apiCall(handler: @escaping (_ response: [EmployeesObj?]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) {(response: EmployeesResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
}
