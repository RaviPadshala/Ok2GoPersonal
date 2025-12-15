//
//  OfflineRequestEndpoint.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 19.08.2020.
//

import Alamofire

class OfflineRequestEndpoint: EndpointItem {

    var offlineRequest: Request
    var file: MediaObj?

    init(offlineRequest: Request) {
        self.offlineRequest = offlineRequest

        if let imageData = offlineRequest.attachedFile, let image = UIImage(data: imageData) {
            file = MediaObj(withImage: image, fileName: "offline_report.jpg")
        }

        guard let endpointType = EndpointItemType(rawValue: offlineRequest.action!) else {
          let endpoint: EndpointItemType = file == nil ? .report : .pictureReport
            super.init(endpointType: endpoint)
            return
        }

        let endpoint: EndpointItemType = file == nil ? endpointType : .pictureReport

        super.init(endpointType: endpoint)
    }

    override func convertToDictionary() -> Parameters? {
        if endpointType == .setAppStatus {
            var dict = [String : Any]()
            
            dict["action"] = offlineRequest.action
            dict["appVersion"] = offlineRequest.appVersion
            dict["gps_settings"] = offlineRequest.hasLocationPermission ? 1 : 0
            dict["gps_enabled"] = offlineRequest.isLocationEnabled ? 1 : 0
            dict["battery_saving"] = Int(offlineRequest.batteryLevel)
            dict["flight_mode"] = offlineRequest.isFlightMode ? 1 : 0
            dict["phone"] = UserDefaultsManager.phoneNumber
            dict["udid"] = UserDefaultsManager.udid

            return dict
        } else {
            var dict = super.getDefaultItems()

            dict["type"]         = offlineRequest.type
            dict["lat"]          = offlineRequest.lat
            dict["lon"]          = offlineRequest.lon
            dict["accuracy"]     = offlineRequest.accuracy
            dict["taskId"]       = offlineRequest.taskId
            dict["remark"]       = offlineRequest.remark
            dict["timestamp"]    = offlineRequest.timestamp
            
            if endpointType == .writeDistance {
            dict["distance"]     = offlineRequest.distance
            }
         
            let locationName = offlineRequest.locationName != -1000 ? offlineRequest.locationName : nil
            dict["extraFields"]     = ["trnsType": offlineRequest.trnsType, "locationName" : locationName]
           
            
            return dict
        }
    }

    func apiCall(handler: @escaping (_ response: Any?, _ error: ErrorObject?) -> Void) {

        if file != nil {
            apiManager.call(type: endpointType, imagesData: [file], params: convertToDictionary()) { (response: ReportResult?, error: ErrorObject?) in
                handler(response, error)
            }
        } else {
            switch endpointType {
            case .report, .reportTracking:
                apiManager.call(type: endpointType, params: convertToDictionary()) { (response: ReportResult?, error: ErrorObject?) in
                    handler(response, error)
                }
                break
            case .writeDistance:
                apiManager.call(type: endpointType, params: convertToDictionary()) { (result: ErrorObject?, error: ErrorObject?) in
                    handler(result, error)
                }
            break
            case .setAppStatus:
                apiManager.call(type: endpointType, params: convertToDictionary()) { (result: ErrorObject?, error: ErrorObject?) in
                    handler(result, error)
                }
                break
            default:
                break
            }

        }
    }

}
