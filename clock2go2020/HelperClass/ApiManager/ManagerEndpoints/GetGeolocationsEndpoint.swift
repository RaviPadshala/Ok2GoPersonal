//
//  GetGeolocations.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/9/20.
//

import Foundation
import Alamofire

class GetGeolocationsEndpoint: EndpointItem {

    init() {
        super.init(endpointType: .getGeolocations)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()

        return dict
    }

    func apiCall(handler: @escaping (_ response: GetGeolocationsObj?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) {(response: GetGeolocationsResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
}
