//
//  AddRideEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 4/5/20.
//

import Alamofire

class AddRideEndpoint: EndpointItem {

    var type: Int
    var param: Double

    init(type: Int, param: Double) {
        self.type = type
        self.param = param

        super.init(endpointType: .addRide)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["type"] = type
        dict["param"] = param

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: ErrorObject?, _: ErrorObject?) in
            handler(result)
        }
    }

}
