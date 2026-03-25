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
            dict["taskName"]       = offlineRequest.taskname
            dict["remark"]       = offlineRequest.remark
            dict["timestamp"]    = offlineRequest.timestamp
            dict["action"] = offlineRequest.action
            
            if endpointType == .writeDistance {
            dict["distance"]     = offlineRequest.distance
            }
        
            if offlineRequest.locationName != -1000 {
                dict["extraFields"]     = ["trnsType": offlineRequest.trnsType, "locationName" : offlineRequest.locationName]
            } else {
                dict["extraFields"]     = ["trnsType": offlineRequest.trnsType]
            }
            
            return dict
        }
    }
    
    func convertToSetAppStatusBodyData() -> Data? {
        
        let jsonString = """
        {
            "action": "\(offlineRequest.action ?? "")",
            "appVersion": "\(offlineRequest.appVersion ?? "")",
            "gps_settings": "\(offlineRequest.hasLocationPermission ? 1 : 0)",
            "gps_enabled": "\(offlineRequest.isLocationEnabled ? 1 : 0)",
            "battery_saving": "\(Int(offlineRequest.batteryLevel))",
            "flight_mode": "\(offlineRequest.isFlightMode ? 1 : 0)",
            "phone": "\(UserDefaultsManager.phoneNumber ?? "")",
            "udid": "\(UserDefaultsManager.udid ?? "")"
        }
        """
        
        return jsonString.data(using: .utf8)
    }

    func apiCall(handler: @escaping (_ response: Any?, _ error: ErrorObject?) -> Void) {

        if file != nil {
            apiManager.call(type: endpointType, imagesData: [file], params: convertToDictionary()) { (response: ReportResult?, error: ErrorObject?) in
                handler(response, error)
            }
        } else {
            switch endpointType {
            case .report, .reportTracking:
                print("params:", convertToDictionary())
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
                let bodyData = convertToSetAppStatusBodyData()
                apiManager.call(type: endpointType, body: bodyData) { (result: ErrorObject?, error: ErrorObject?) in
                    handler(result, error)
                }
                break
            default:
                break
            }

        }
    }

}
