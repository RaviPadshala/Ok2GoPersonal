//
//  UpdateTask.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import Alamofire

class UpdateTaskEndpoint: EndpointItem {

    var taskId: Int?
    var taskCode: Int?
    var taskName: String?
    var projectId: Int?
    var hourPrice: Int?
    var budgetHours: Int?

    init(taskId: Int, taskCode: Int, taskName: String, projectId: Int, hourPrice: Int, budgetHours: Int  ) {

        self.taskId = taskId
        self.taskCode = taskCode
        self.taskName = taskName
        self.projectId = projectId
        self.hourPrice = hourPrice
        self.budgetHours = budgetHours

            super.init(endpointType: .updateTask)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["taskId"] = taskId
        dict["taskCode"] = taskCode
        dict["taskName"] = taskName
        dict["projectId"] = projectId
        dict["hourPrice"] = hourPrice
        dict["budgetHours"] = budgetHours

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }
    }

}
