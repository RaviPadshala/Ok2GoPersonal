//
//  CloseMonthEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/24/20.
//

import Foundation
import Alamofire

class CloseMonthReportEndpoint: EndpointItem {
    var month: String?
    var email: String?
    var cell : String?

    init(month: String, email: String? = "", cell: String?) {
        self.month = month
        self.email = email
        self.cell  = cell
        
        super.init(endpointType: .closeMonth)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

         dict["month"] = month
         dict["email"] = email
         dict["cell"]  = cell

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: ErrorObject?, _: ErrorObject?) in
            handler(result)
        }
    }
}
