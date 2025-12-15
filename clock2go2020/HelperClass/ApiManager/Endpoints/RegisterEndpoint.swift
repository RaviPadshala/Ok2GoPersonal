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

        dict["phone"] = phone
        dict["notificationId"] = notificationID
        dict["cellType"] = "iOS"
 
        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }
    }

}
