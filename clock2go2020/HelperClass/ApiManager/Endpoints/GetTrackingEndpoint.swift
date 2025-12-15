//
//  GetTrackingEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 3/2/20.
//

import Alamofire

class GetTrackingEndpoint: EndpointItem {

    init() {
        super.init(endpointType: .getTracking)
    }

    override func convertToDictionary() -> Parameters? {
        let dict = super.getDefaultItems()
        return dict
    }

    func apiCall(handler: @escaping (_ response: TrackingResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: TrackingResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }
}
