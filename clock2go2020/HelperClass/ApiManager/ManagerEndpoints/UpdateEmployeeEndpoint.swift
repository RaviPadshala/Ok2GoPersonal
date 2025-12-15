//
//  UpdateEmployeeEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import Alamofire

class  UpdateEmployeeEndpoint: EndpointItem {

    var employee: EmployeeObj?

    init(employee: EmployeeObj?) {
        self.employee = employee

        super.init(endpointType: .updateEmployee)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["empId"] = employee?.empId
        dict["empCode"] = employee?.empCode
        dict["empName"] = employee?.empName
        dict["deptIds"] = employee?.deptIds
        dict["reportWay"] = employee?.reportWay
        dict["empPhone"] = employee?.empPhone
        dict["empEmail"] = employee?.empEmail

        return dict
    }

    func apiCall(handler: @escaping (_ response: [EmployeesObj?]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: EmployeesResult?, error: ErrorObject?) in
            handler(result?.data, error)
        }
    }

}
