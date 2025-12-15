//
//  UpdateEmpReportEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 3/23/20.
//

import Alamofire

class UpdateEmpReportEndpoint: EndpointItem {

    var type: String?
    var date: String?
    var reportId: Int?
    var remark: String?
    var taskId: String?
    var taskName: String?
    var extraFields: [String: Any]?
    
    init(type: String?, date: String?, reportId: Int?, remark: String? = nil, taskId: String? = nil, taskName: String? = nil, extraFields: [String: Any]? = nil) {

        self.type = type
        self.date = date
        self.reportId = reportId
        self.remark = remark
        self.taskId = taskId
        self.taskName = taskName
        self.extraFields = extraFields
        
        super.init(endpointType: .updateEmpRep)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        if type != nil {
            dict["type"] = type
        }

        if date != nil {
            dict["date"] = date
        }

        if reportId != nil {
            dict["reportId"] = reportId
        }

        if remark != nil {
            dict["remark"] = remark
        }

        if taskId != nil {
            dict["taskId"] = taskId
        }
        
        if taskName != nil {
            dict["taskName"] = taskName
        }
        
        if extraFields != nil {
            dict["extraFields"] = extraFields
        }

        return dict
    }

    func apiCall(handler: @escaping (_ response: [String: EmpDayReportsObj]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: EmpUpdateReportsResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }
}
