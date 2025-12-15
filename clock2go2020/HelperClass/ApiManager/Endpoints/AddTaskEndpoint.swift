//
//  AddTaskEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 1/28/20.
//

import Alamofire

class AddTaskEndpoint: EndpointItem {

    var taskName: String

    init(taskName: String) {
        self.taskName = taskName

        super.init(endpointType: .addTask)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["taskName"] = taskName

        return dict
    }

    func apiCall(handler: @escaping (_ response: AddTaskResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: AddTaskResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}
