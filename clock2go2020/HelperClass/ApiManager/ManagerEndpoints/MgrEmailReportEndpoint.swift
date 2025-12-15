//
//  MgrEmailReportEndpoint.swift
//  clock2go2020
//
//  Created by Gleb on 14.12.2020.
//

import Foundation
import Alamofire

class MgrEmailReportEndpoint: EndpointItem {
    var month: String?
    var email: String?
    var type: Int?
    var format: String?

    init(month: String?, email: String?, type: Int?, format: String?) {
        self.month = month
        self.email = email
        self.type = type
        self.format = format

        super.init(endpointType: .sendMgrEmail)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["month"] = month
        dict["email"] = email
        dict["type"] = type
        dict["format"] = format

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: ErrorObject?, _: ErrorObject?) in
            handler(result)
        }
    }

}
