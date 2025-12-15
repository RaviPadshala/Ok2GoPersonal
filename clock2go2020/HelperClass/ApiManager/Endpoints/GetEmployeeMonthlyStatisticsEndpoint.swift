//
//  GetEmployeeMonthlyStatistics.swift
//  clock2go2020
//
//  Created by Admin on 3/25/20.
//

import Alamofire

class GetEmployeeMonthlyStatisticsEndpoint: EndpointItem {

    init() {
        super.init(endpointType: .getEmpMonthlyStat)
    }

    override func convertToDictionary() -> Parameters? {
        return super.getDefaultItems()
    }

    func apiCall(handler: @escaping (_ response: [String: MonthObj]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: EmpMonthlyStatsResult?, error: ErrorObject?) in
            handler(result?.data, error)
        }
    }

}
