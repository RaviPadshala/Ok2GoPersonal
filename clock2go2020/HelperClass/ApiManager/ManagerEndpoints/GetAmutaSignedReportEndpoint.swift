//
//  GetAmutaSignedReportEndpoint.swift
//  clock2go2020
//
//  Created by Gleb on 22.10.2020.
//

import Foundation
import Alamofire

class GetAmutaSignedReportEndpoint: EndpointItem {

    var month: String
    var empId: Int

    init(month: String, empId: Int) {
        self.month = month
        self.empId = empId

        super.init(endpointType: .getAmutaSignedReport)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["month"] = month
        dict["empId"] = empId

        return dict
    }

    func apiCall(handler: @escaping (_ response: [GetAmutaSignedReportObj]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: GetAmutaSignedReportResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }

}
