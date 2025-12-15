//
//  ShowHealthDisclaimerEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/27/20.
//

import Foundation
import Alamofire

class ShowHealthDisclaimerEndpoint: EndpointItem {

    init() {

        super.init(endpointType: .showHealthDisclaimer)
    }

    override func convertToDictionary() -> Parameters? {
        let dict = super.getDefaultItems()
        return dict
    }
    func apiCall(handler: @escaping (_ response: HealthDisclaimerObj?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: ShowHealthDisclaimerResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
}
