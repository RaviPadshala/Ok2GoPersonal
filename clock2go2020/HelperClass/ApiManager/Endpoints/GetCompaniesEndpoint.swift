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
    
    func convertToBodyData() -> Data? {
        let dict = super.getDefaultItems()
        
        let jsonString = """
        {
            "action": "\(dict["action"] ?? "")",
            "empId": "\(dict["empId"] ?? "")",
            "phone": "\(dict["phone"] ?? "")",
            "udid": "\(dict["udid"] ?? "")",
            "appVersion": "\(dict["appVersion"] ?? "")",
            "agent": "\(dict["agent"] ?? "")",
            "lang": "\(dict["lang"] ?? "")",
            "timezone": "\(dict["timezone"] ?? "")"
        }
        """
        
        return jsonString.data(using: .utf8)
    }
    
    func apiCall(handler: @escaping (_ response: CompanyResult?, _ error: ErrorObject?) -> Void) {
        let bodyData = convertToBodyData()
        apiManager.call(type: endpointType, body: bodyData) { (response: CompanyResult?, error: ErrorObject?) in
            handler(response, error)
        }
        
    }
}
