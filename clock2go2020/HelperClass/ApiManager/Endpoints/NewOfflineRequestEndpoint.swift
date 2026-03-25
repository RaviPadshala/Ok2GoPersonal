//
//  OfflineRequestEndpoint.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 19.08.2020.
//

import Alamofire

class NewOfflineRequestEndpoint: EndpointItem {


    init(action: String) {
       
        guard let endpointType = EndpointItemType(rawValue: action) else {
          let endpoint: EndpointItemType = .report
            super.init(endpointType: endpoint)
            return
        }

        let endpoint: EndpointItemType = endpointType

        super.init(endpointType: endpoint)
    }
    
    func converEndReportData(params: [String: Any]) -> Data? {
        
        var jsonString = """
        {
            "action": "\(params["action"] ?? "")",
            "empId": "\(params["empId"] ?? "")",
            "phone": "\(params["phone"] ?? "")",
            "udid": "\(params["udid"] ?? "")"
        """
        
        // extraFields (JSON)
        if let extraFields = params["extraFields"],
           let data = try? JSONSerialization.data(withJSONObject: extraFields),
           let json = String(data: data, encoding: .utf8) {
            jsonString += """
            ,
            "extraFields": \(json)
            """
        }
        
        // type
        if let type = params["type"] {
            jsonString += """
            ,
            "type": "\(type)"
            """
        }
        
        // location
        if let lon = params["lon"] {
            jsonString += """
            ,
            "lon": \(lon)
            """
        }
        
        if let lat = params["lat"] {
            jsonString += """
            ,
            "lat": \(lat)
            """
        }
        
        if let accuracy = params["accuracy"] {
            jsonString += """
            ,
            "accuracy": \(accuracy)
            """
        }
        
        // timestamp
        if let timestamp = params["timestamp"] {
            jsonString += """
            ,
            "timestamp": \(timestamp)
            """
        }
        
        // ending fields
        jsonString += """
            ,
            "appVersion": "\(params["appVersion"] ?? "")",
            "agent": "\(params["agent"] ?? "")",
            "lang": "\(params["lang"] ?? "")",
            "timezone": "\(params["timezone"] ?? "")"
        }
        """
        
        return jsonString.data(using: .utf8)
    }
    
    func offlineReportApiCall(_ params: Parameters, handler: @escaping (_ response: Any?, _ error: ErrorObject?) -> Void) {

        switch endpointType {
        case .report, .reportTracking:
            print("params:", params)
            
            if let type = params["type"] as? Int, type == 2, !params.keys.contains("taskId") {
                apiManager.call(type: endpointType, body: self.converEndReportData(params: params)) { (response: ReportResult?, error: ErrorObject?) in
                    handler(response, error)
                }
            } else {
                apiManager.call(type: endpointType, params: params) { (response: ReportResult?, error: ErrorObject?) in
                    handler(response, error)
                }
            }
            
            
        default:
            break
        }
    }

}
