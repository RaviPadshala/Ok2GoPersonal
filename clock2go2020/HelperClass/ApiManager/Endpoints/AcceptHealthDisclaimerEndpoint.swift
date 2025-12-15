//
//  AcceptHealthDisclaimerEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/27/20.
//

import Foundation
import Alamofire

class AcceptHealthDisclaimerEndpoint: EndpointItem {

    init() {

        super.init(endpointType: .acceptHealthDisclaimer)
    }

    override func convertToDictionary() -> Parameters? {
        let dict = super.getDefaultItems()
        return dict
    }

    func apiCall(handler: @escaping (_ response: [ReportObj?]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: ReportResult?, error: ErrorObject?) in
            handler(result?.data, error)
        }
    }
}
