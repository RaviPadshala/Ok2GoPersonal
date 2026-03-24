//
//  GetCompaniesEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 1/28/20.
//

import Alamofire

class GetCompaniesEndpoint: EndpointItem {
    
    init() {
        super.init(endpointType: .getCompanies)
    }
    
    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
//        dict["udid"] = "iLWnfn7gev7bFzbO"
//        dict["phone"] = "0528559938"
        
        var newDict = [String: Any]()
        newDict["action"] = dict["action"]
        newDict["empId"] = dict["empId"]
        newDict["phone"] = dict["phone"]
        newDict["udid"] = dict["udid"]
        newDict["appVersion"] = dict["appVersion"]
        newDict["agent"] = dict["agent"]
        newDict["lang"] = dict["lang"]
        newDict["timezone"] = dict["timezone"]
        
        
        return newDict
    }
    
    func apiCall(handler: @escaping (_ response: CompanyResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: CompanyResult?, error: ErrorObject?) in
            handler(response, error)
        }
        
    }
}
