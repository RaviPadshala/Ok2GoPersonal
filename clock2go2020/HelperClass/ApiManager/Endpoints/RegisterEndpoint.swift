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
        let dict = super.getDefaultItems()
        
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
    
    func convertToBodyData() -> Data? {
        let dict = super.getDefaultItems()
        
        let jsonString = """
        {
            "action": "\(dict["action"] ?? "")",
            "phone": "\(phone)",
            "notificationId": "\(notificationID)",
            "cellType": "iOS",
            "lang": "\(dict["lang"] ?? "")",
            "agent": "\(dict["agent"] ?? "")",
            "timezone": "\(dict["timezone"] ?? "")",
            "appVersion": "\(dict["appVersion"] ?? "")"
        }
        """
        
        return jsonString.data(using: .utf8)
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        let bodyData = convertToBodyData()
        apiManager.call(type: endpointType, body: bodyData) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }
    }

}
