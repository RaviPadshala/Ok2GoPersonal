//
//  GetMgrEmpReportsEndpont.swift
//  clock2go2020
//
//  Created by Gleb on 02.12.2020.
//

import Foundation
import Alamofire

class GetMgrEmpReportsEnpoint: EndpointItem {

    var month: String
    var empId: Int

    init(month: String, empId: Int ) {
        self.month = month
        self.empId = empId

        super.init(endpointType: .getMgrEmpReports)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        dict["token"] = ManagerAppDataManager.shared.getManagerToken()

        dict["month"] = month

        dict["empId"] = empId

        return dict
    }

    func apiCall(handler: @escaping (_ response: [String: GetMgrEmpReportsObj]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: GetMgrEmpReportsResult?, error: ErrorObject?) in
            handler(result?.data, error)
        }
    }

}
