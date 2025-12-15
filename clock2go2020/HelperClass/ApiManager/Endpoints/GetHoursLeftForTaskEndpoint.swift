//
//  GetHoursLeftForTaskEndpoint.swift
//

import Alamofire

class GetHoursLeftForTaskEndpoint: EndpointItem {
    
    let patientId: String

    init(patientId: String) {
        
        self.patientId = patientId

        super.init(endpointType: .getPatientLeftHours)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["patientId"] = patientId

        return dict
    }

    func apiCall(handler: @escaping (_ response: HoursLeftForTaskResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: HoursLeftForTaskResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}

