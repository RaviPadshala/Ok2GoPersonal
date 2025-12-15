//
//  GetMonthStatusEdpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/9/20.
//

import Foundation
import Alamofire

class GetMonthSummaryEndpoint: EndpointItem {

    var month: String?
    var empId: Int?

    init(month: String, empId: Int?) {
        self.month = month
        self.empId = empId

        super.init(endpointType: .getMonthSummary )
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["month"] = month
        dict["empId"] = empId

        return dict
    }

    func apiCall(handler: @escaping (_ response: [GetMonthSummaryObj], _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: GetMonthSummaryResult?, error: ErrorObject?) in
            handler(response?.data ?? [], error)
        }
    }

}
