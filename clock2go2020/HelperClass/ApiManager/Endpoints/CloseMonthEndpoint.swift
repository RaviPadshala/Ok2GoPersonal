//
//  CloseMonthEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/23/20.
//

import Foundation

class CloseMonthEndpoint: EndpointItem {

    var month: String?
    var email: String?
    var format: String?
    var type: Int?

    init(endpointType: EndpointItemType, month: String? = nil, email: String?,
         format: String?, type: Int?) {

        self.month = month
        self.email = email
        self.format = format
        self.type = type

        super.init(endpointType: endpointType)
    }

    func apiCall(handler: @escaping (_ response: CompanyResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: CompanyResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }
}
