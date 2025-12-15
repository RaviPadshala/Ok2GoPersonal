//
//  AcceptTrackDisclaimerEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 4/9/20.
//

import Alamofire

class AcceptTrackDisclaimerEndpoint: EndpointItem {
    var empId: Int

    init(empId: Int) {
        self.empId = empId

        super.init(endpointType: .acceptTrackDisclaimer)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["empId"] = empId

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: ErrorObject?, _: ErrorObject?) in
            handler(result)
        }
    }
}
