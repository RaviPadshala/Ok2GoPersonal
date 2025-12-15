//
//  EmployeeEndpoint .swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import Alamofire

class EmployeeEndpoint: EndpointItem {
    var empId: Int?

    init(empId: Int) {
        self.empId = empId

        super.init(endpointType: .getEmployee)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["empId"] = empId
        dict["token"] = ManagerAppDataManager.shared.getManagerToken()

        return dict
    }

    func apiCall(handler: @escaping (_ response: EmployeeObj?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) {(response: EmployeeResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
}
