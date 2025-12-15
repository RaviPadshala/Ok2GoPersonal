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

        if date != nil {
            dict["date"] = date
        }

        if reportId != nil {
            dict["reportId"] = reportId
        }

        return dict
    }

    func apiCall(handler: @escaping (_ response: [String: EmpDayReportsObj]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: EmpUpdateReportsResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }

}
