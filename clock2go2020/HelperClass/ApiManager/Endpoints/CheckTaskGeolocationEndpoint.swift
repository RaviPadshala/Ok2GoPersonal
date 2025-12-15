//
//  CheckTaskGeolocationEndpoint.swift
//  clock2go2020
//
//  Created by Gleb on 27.01.2021.
//

import Foundation
import Alamofire

class CheckTaskGeolocationEndpoint: EndpointItem {

    var empId: String?
    var taskId: String?
    var latitude: Double?
    var longitude: Double?
    var accuracy: Int?

    init(empId: String, taskId: String, latitude: Double, longitude: Double, accuracy: Int) {
        self.empId = empId
        self.taskId = taskId
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy

        super.init(endpointType: .checkTaskGeolocation)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["empId"] = empId
        dict["taskId"] = taskId
        dict["latitude"] = latitude
        dict["longitude"] = longitude
        dict["accuracy"] = accuracy

        return dict
    }
    func apiCall(handler: @escaping (_ response: CheckTaskGeolocationObj?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: CheckTaskGeolocationResult?, error: ErrorObject?) in
            handler(result?.data, error)
        }
    }
}
