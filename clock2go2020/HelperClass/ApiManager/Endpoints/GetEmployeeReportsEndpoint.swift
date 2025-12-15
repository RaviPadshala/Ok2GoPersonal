//
//  GetEmployeeReportsEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 3/10/20.
//

import UIKit
import Alamofire

class GetEmployeeReportsEndpoint: EndpointItem {
    
    var month: String
    
    init(month: String) {
        self.month = month
        
        super.init(endpointType: .getEmpReports)
    }
    
    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        
        dict["month"] = month
        
        return dict
    }
    
    func apiCall(handler: @escaping (_ response: EmpReportsObj?, _ error: ErrorObject?) -> Void) {
        print("convertToDictionary() getEmpReports", convertToDictionary())
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: EmpReportsResult?, error: ErrorObject?) in
            handler(result?.data, error)
        }
    }
    
}

class GetEmployeeReportsEndpointWithCompanyChnageFromReport: EndpointItem {
    
    var month: String
    var empId : String
    
    init(month: String,empId : String) {
        self.month = month
        self.empId = empId
        
        super.init(endpointType: .getEmpReports)
    }
    
    override func convertToDictionary() -> Parameters? {
        
        
        
        
        var items = [String: Any]()
        items["month"] = month
        
        
        items["action"] = endpointType.rawValue
        
        
        
        items["agent"] = UAString()
        
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            items["appVersion"] = appVersion
        }
        
        items["timezone"] = TimeZone.current.identifier
        
        items["lang"] = UserDefaultsManager.appleLanguagesNew.first ?? "en"
        
        // Get user phone number.
        if let phone = UserDefaultsManager.phoneNumber {
            items["phone"] = phone
        }
        
        // Get user udid - except endpointType: register and verify_code
        if let udid = UserDefaultsManager.udid {
            items["udid"] = udid
        }
        
        // Get user empId - except endpointType: register, verify_code and get_companies
        
        items["empId"] = empId
        
        return items
        
    }
    
    func apiCall(handler: @escaping (_ response: EmpReportsObj?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: EmpReportsResult?, error: ErrorObject?) in
            handler(result?.data, error)
        }
    }
    
}

