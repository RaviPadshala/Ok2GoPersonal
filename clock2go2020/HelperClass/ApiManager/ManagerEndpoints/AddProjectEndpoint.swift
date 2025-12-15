//
//  AddProject.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import Alamofire

class AddProjectEndpoint: EndpointItem {
    var projectCode: Int?
    var projectName: String?

    init(projectCode: Int, projectName: String) {

        self.projectCode = projectCode
        self.projectName = projectName

        super.init(endpointType: .addProject)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["projectCode"] = projectCode
        dict["projectName"] = projectName

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }
    }

}
