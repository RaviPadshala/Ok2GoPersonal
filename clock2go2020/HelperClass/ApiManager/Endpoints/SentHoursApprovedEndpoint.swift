//
//  SentHoursApprovedEndpoint.swift
//  clock2go2020
//
//  Created by Mac on 19/03/24.
//


import Alamofire

class SentHoursApprovedEndpoint : EndpointItem {
    
    
    
    var hourId: Int?

    var hourApproved: Int?

    init( hourId: Int? = nil, hourApproved: Int? = nil) {

        self.hourId = hourId
        self.hourApproved = hourApproved
        
        
        super.init(endpointType: .sentHoursApproved)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

      

        if hourId != nil {
            dict["hours_approved_id"] = hourId
        }
        if hourApproved != nil {
            dict["hours_approved_total"] = hourApproved
        }


        return dict
    }

    func apiCall(handler: @escaping (_ response: Any?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: SentHoursApprovedResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}
