//
//  RegisterEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 1/28/20.
//

import Alamofire

class RegisterEndpoint: EndpointItem {

    var phone: String
    var notificationID: String

    init(phone: String, notificationID: String) {
        self.phone = phone
        self.notificationID = notificationID

        super.init(endpointType: .register)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        
        var newDict = [String: Any]()
        newDict["action"] = dict["action"]
        newDict["phone"] = phone
        newDict["notificationId"] = notificationID
        newDict["cellType"] = "iOS"
        newDict["lang"] = dict["lang"]
        newDict["agent"] = dict["agent"]
        newDict["timezone"] = dict["timezone"]
        newDict["appVersion"] = dict["appVersion"]
    
        return newDict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }
    }

}
