//
//  GetExitEnforcementEndpoint.swift
//  clock2go2020
//
//  Created by Gleb on 27.01.2021.
//

import Foundation
import Alamofire

class GetExitEnforcementEndpoint: EndpointItem {

    var taskId: String?

    init(taskId: String) {
        self.taskId = taskId

        super.init(endpointType: .getExitEnforcement)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["taskId"] = taskId
        return dict
    }
    func apiCall(handler: @escaping (_ response: GetExitEnforcementObj?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: GetExitEnforcementResult?, error: ErrorObject?) in
            handler(result?.data, error)
        }
    }
}
