//
//  EchoEndpoint.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 27.07.2022.
//

import Alamofire

class EchoEndpoint: EndpointItem {

    init() {
        super.init(endpointType: .echoAction)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = [String : Any]()
        dict["action"] = endpointType.rawValue
        dict["phone"] = UserDefaultsManager.phoneNumber
        dict["udid"] = UserDefaultsManager.udid

        return dict
    }

    func apiCall(handler: @escaping (_ response: AddTaskResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: AddTaskResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}

