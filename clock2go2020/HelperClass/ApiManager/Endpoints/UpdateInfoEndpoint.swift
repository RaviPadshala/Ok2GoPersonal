//
//  UpdateInfoEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 2/13/20.
//

import Alamofire

class UpdateInfoEndpoint: EndpointItem {

    var name: String?
    var email: String?

    init(name: String, email: String? = "") {
        self.name = name
        self.email = email

        super.init(endpointType: .updateInfo)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["name"] = name

        if email != nil {
            dict["email"] = email
        }

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }
    }

}
