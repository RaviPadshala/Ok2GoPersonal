//
//  GetMonthlyStatsEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import Alamofire

class MonthlyStatsEndpoint: EndpointItem {
    var month: String?
    var empId: Int?

    init(month: String, empId: Int?) {
        self.month = month
        self.empId = empId
        super.init(endpointType: .getMonthStats )
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["month"] = month
        dict["empId"] = empId

        return dict
    }

    func apiCall(handler: @escaping (_ response: MonthStatsObj?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: MonthStatsResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
}
