//
//  DepartmentsEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Alamofire

class DepartmentsEndpoint: EndpointItem {

    init() {
        super.init(endpointType: .getDepartments)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()

        return dict
    }

    func apiCall(handler: @escaping (_ response: [DepartmentsObj?]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) {(response: DepartmentsResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
}
