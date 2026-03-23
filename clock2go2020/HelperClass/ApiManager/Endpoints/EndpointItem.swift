//
//  EndpointItem.swift
//  clock2go2020
//
//  Created by Admin on 1/28/20.
//

import UIKit
import Alamofire

class EndpointItem: NSObject {
    
    var apiManager = APIManager.shared()
    
    var endpointType: EndpointItemType
    var params: Parameters?
    
    init(endpointType: EndpointItemType) {
        self.endpointType = endpointType
    }
    
    func convertToDictionary() -> [String: Any]? {
        return nil
    }
    
    /**
     Gets default query params that should be sent to all API requests.
     
     - returns: List of URLQueryItem objects representing relevant params.
     */
    func getDefaultItems() -> [String: Any] {
        var items = [String: Any]()
        
        if endpointType == .pictureReport {
            items["action"] = "write_report"
        } else {
            items["action"] = endpointType.rawValue
        }
        
        // Get user phone number.
        if let phone = UserDefaultsManager.phoneNumber {
            items["phone"] = phone
        }
        
        // Get user empId - except endpointType: register, verify_code and get_companies
        if let empId = UserDefaultsManager.empId {
            items["empId"] = empId
        }
        
        // Get user udid - except endpointType: register and verify_code
        if let udid = UserDefaultsManager.udid {
            items["udid"] = udid
        }
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            items["appVersion"] = appVersion
        }
        
        
        items["agent"] = UAString()
        
        items["timezone"] = TimeZone.current.identifier
        
        items["lang"] = UserDefaultsManager.appleLanguagesNew.first ?? "en"
        
        
        
        return items
    }
    
}
