//
//  WriteReportEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 4/22/20.
//

import Alamofire

class WriteReportEndpoint: EndpointItem {
    
    var type: Int
    var lat: Double?
    var lon: Double?
    var accuracy: Int?
    
    var remark: String?
    var actionType: Int?
    
    init(type: Int, lat: Double? = nil, lon: Double? = nil, accuracy: Int? = nil, remark: String? = nil, actionType: Int? = nil) {
        self.type = type
        self.lat = lat
        self.lon = lon
        self.accuracy = accuracy
        
        self.remark = remark
        self.actionType = actionType
        
        super.init(endpointType: .report)
    }
    
    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        
        dict["type"] = type
        dict["lat"] = lat
        dict["lon"] = lon
        dict["accuracy"] = accuracy
        
        
        dict["remark"] = remark
        dict["action_type"] = actionType
        
        return dict
    }
    
    func convertWriteReportData() -> Data? {
        let dict = super.getDefaultItems()
        
        let jsonString = """
        {
            "action": "\(dict["action"] ?? "")",
            "empId": "\(dict["empId"] ?? "")",
            "phone": "\(dict["phone"] ?? "")",
            "udid": "\(dict["udid"] ?? "")",
            "type": "\(type)",
            "lon": \(lon ?? 0),
            "lat": \(lat ?? 0),
            "accuracy": \(accuracy ?? 0),
            "appVersion": "\(dict["appVersion"] ?? "")",
            "agent": "\(dict["agent"] ?? "")",
            "lang": "\(dict["lang"] ?? "")",
            "timezone": "\(dict["timezone"] ?? "")"
        }
        """
        
        return jsonString.data(using: .utf8)
    }
    
    func apiCall(handler: @escaping (_ response: ReportResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, body: convertWriteReportData()) { (response: ReportResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }
}
