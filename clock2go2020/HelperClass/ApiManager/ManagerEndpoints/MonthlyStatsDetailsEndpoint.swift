//
//  MonthlyStatsDetailsEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 4/14/20.
//

import Alamofire

class MonthlyStatsDetailsEndpoint: EndpointItem {

    var month: String?

    init(month: String) {
        self.month = month

        super.init(endpointType: .getMonthStatsDetails)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["month"] = month

        return dict
    }

    func apiCall(handler: @escaping (_ response: MonthStatsDetailsObj?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: MonthStatsDetailsResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }

}
