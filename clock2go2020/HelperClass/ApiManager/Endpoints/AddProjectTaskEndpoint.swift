//
//  AddProjectTaskEndpoint.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 29.06.2022.
//

import Alamofire

class AddProjectTaskEndpoint: EndpointItem {

    let taskName: String
    let projectId: String

    init(taskName: String, projectId: String) {
        self.taskName = taskName
        self.projectId = projectId

        super.init(endpointType: .addProjectTask)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["taskName"] = taskName
        dict["projectId"] = projectId

        return dict
    }

    func apiCall(handler: @escaping (_ response: AddTaskResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: AddTaskResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}
