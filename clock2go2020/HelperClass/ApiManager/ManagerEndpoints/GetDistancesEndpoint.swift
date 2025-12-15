//
//  GetDistances.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/9/20.
//

import Foundation
import Alamofire

class GetDistancesEndpoint: EndpointItem {

    init() {
        super.init(endpointType: .getDistances)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()

        return dict
    }

    func apiCall(handler: @escaping (_ response: GetDistancesObj?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) {(response: GetDistancesResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
}
