//
//  PatientNotAtHomeEndpoint.swift
//  clock2go2020
//
//  Created by Kamal Punia on 26/10/23.
//

import Alamofire

class PatientNotAtHomeEndpoint: EndpointItem {
    
    let latitude: Double?
    let longitude: Double?
    let taskID: String?
    
    init(latitude: Double?, longitude: Double?, taskID: String?) {
        
        self.latitude = latitude
        self.longitude = longitude
        self.taskID = taskID

        super.init(endpointType: .patientNotAtHome)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        dict["lat"] = self.latitude
        dict["lon"] = self.longitude
        dict["taskId"] = self.taskID
        return dict
    }

    func apiCall(handler: @escaping (_ response: Any?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: PatientNotAtHomeResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }
}

