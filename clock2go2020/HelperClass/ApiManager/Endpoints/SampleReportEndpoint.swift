//
//  SampleReportEndpoint.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 24.08.2022.
//

import Alamofire

class SampleReportEndpoint: EndpointItem {

    var type: ReportActionType
    var taskId: String?
    var taskName: String?
    var remark: String?

    var lat: Double?
    var lon: Double?
    var accuracy: Int?

    
    var wifi: String?

    var empIds: [Int]?
    var extraFields: [String: Any]?

    init(endpointType: EndpointItemType = .report, type: ReportActionType, taskId: String? = nil, taskName: String? = nil, remark: String? = nil, lat: Double? = nil, lon: Double? = nil, accuracy: Int? = nil, wifi: String? = nil, empIds: [Int]? = nil, extraFields: [String: Any]? = nil) {

        self.taskId = taskId
        self.taskName = taskName
        self.type = type
        self.remark = remark

        self.lat = lat
        self.lon = lon
        self.accuracy = accuracy

        
        self.wifi = wifi

        self.empIds = empIds
        self.extraFields = extraFields
        
        super.init(endpointType: endpointType)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["type"] = type.rawValue

        if lat != nil {
            dict["lat"] = lat
        }

        if lon != nil {
            dict["lon"] = lon
        }

        if accuracy != nil {
            dict["accuracy"] = accuracy
        }

        if taskId != nil {
            dict["taskId"] = taskId
        }
        
        if taskName != nil {
            dict["taskName"] = taskName
        }

        if remark != nil {
            dict["remark"] = remark
        }

        

        if wifi != nil {
            dict["wifi"] = wifi
        }

        dict["empIds"] = empIds
        dict["extraFields"] = extraFields

        return dict
    }

    func apiCall(handler: @escaping (_ response: SampleReportResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: SampleReportResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}
