//
//  DeleteEmpReportEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 3/29/20.
//

import Alamofire

class DeleteEmpReportEndpoint: EndpointItem {

    var reportId: Int?
    var date: String?

    init(reportId: Int?) {
        self.reportId = reportId
        self.date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")

        super.init(endpointType: .deleteEmpRep)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()
        
        var newDict = [String: Any]()
        
        newDict["action"] = dict["action"]
        newDict["empId"] = dict["empId"]
        newDict["phone"] = dict["phone"]
        newDict["agent"] = dict["agent"]
        newDict["udid"] = dict["udid"]
        
        if reportId != nil {
            newDict["reportId"] = reportId
        }
        
        if date != nil {
            newDict["date"] = date
        }
        
        newDict["timezone"] = dict["timezone"]
        newDict["appVersion"] = dict["appVersion"]
        newDict["lang"] = dict["lang"]

        return newDict
    }

    func apiCall(handler: @escaping (_ response: [String: EmpDayReportsObj]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: EmpUpdateReportsResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }

}
