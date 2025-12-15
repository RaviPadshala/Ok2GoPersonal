//
//  ReportPictureEndpoint.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 11.08.2020.
//

import UIKit
import Alamofire

class ReportPictureEndpoint: EndpointItem {

    var reportPicture: ReportPictureObj
    var location: LocationObj

    init(reportPicture: ReportPictureObj) {
        self.reportPicture = reportPicture
        self.location = LocationObj()

        super.init(endpointType: .pictureReport)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["type"] = reportPicture.reportType.rawValue

        dict["lat"] = location.lat
        dict["lon"] = location.lon
        dict["accuracy"] = location.accuracy

        dict["taskId"] = reportPicture.task?.taskId

        dict["remark"] = reportPicture.remark

      

        return dict
    }

    func apiCall(handler: @escaping (_ response: ReportResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, imagesData: reportPicture.attachedFiles, params: convertToDictionary()) { (response: ReportResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}
