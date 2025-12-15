//
//  GetTasksEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import Alamofire

class GetTasksEndpoint: EndpointItem {

    init() {
        super.init(endpointType: .getTasks)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()

        return dict
    }

    func apiCall(handler: @escaping (_ response: [GetTasksObj?]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: GetTasksResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
}
