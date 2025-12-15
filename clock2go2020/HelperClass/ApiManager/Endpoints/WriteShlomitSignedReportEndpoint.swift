//
//  WriteShlomitSignedReportEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 4/28/20.
//

import Alamofire

class WriteShlomitSignedReportEndpoint: EndpointItem {

    var files: [MediaObj?]

    var fromDate: String
    var toDate: String

    init(files: [MediaObj] = [], fromDate: String, toDate: String) {
        self.files = files

        self.fromDate = fromDate
        self.toDate = toDate

        super.init(endpointType: .writeShlomitReport)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["fromDate"] = fromDate
        dict["toDate"] = toDate

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, imagesData: files, params: convertToDictionary()) { (_: ErrorObject?, error: ErrorObject?) in
            handler(error)
        }
    }

}
