//
//  ReportAbsenceEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import Alamofire

class ReportAbsenceEndpoint: EndpointItem {

    var files: [MediaObj?]

    var remark: String?
    var fromDate: String
    var toDate: String

    var lat: Float?
    var lon: Float?
    var accuracy: Int?

//    var appVersion: String
    var wifi: String

    init(type: ReportActionType, files: [MediaObj] = [], remark: String? = "", fromDate: String, toDate: String, lat: Float?, lon: Float?, accuracy: Int?, wifi: String) {

        self.files = files

        self.remark = remark
        self.fromDate = fromDate
        self.toDate = toDate

        self.lat = lat
        self.lon = lon
        self.accuracy = accuracy

        //self.appVersion = appVersion
        self.wifi = wifi

        super.init(endpointType: .reportAbsence)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["type"] = "10"

        dict["fromDate"] = fromDate
        dict["toDate"] = toDate

        dict["lat"] = lat
        dict["lon"] = lon
        dict["accuracy"] = accuracy

        dict["remark"] = remark

//        dict["appVersion"] = appVersion
//        dict["agent"] = UAString()
        dict["wifi"] = wifi

        return dict
    }

    func apiCall(handler: @escaping (_ response: ReportResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, imagesData: files, params: convertToDictionary()) { (response: ReportResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }
}
