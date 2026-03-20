//
//  AppStatusEndpoint.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 25.11.2021.
//

import Alamofire

//ReportEndpoint
class AppStatusEndpoint: EndpointItem {

    var appVersion: String
    var hasGPSPermission: Bool
    var gpsEnabled: Bool
    var batterySaving: Int
    var flightMode: Bool

    init(endpointType: EndpointItemType = .setAppStatus, appVersion: String, hasGPSPermission: Bool, gpsEnabled: Bool, batterySaving: Int/*%*/, flightMode: Bool) {
        self.appVersion = appVersion
        self.hasGPSPermission = hasGPSPermission
        self.gpsEnabled = gpsEnabled
        self.batterySaving = batterySaving
        self.flightMode = flightMode

        super.init(endpointType: endpointType)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = [String : Any]()
        dict["action"] = "app_status"
        dict["phone"] = UserDefaultsManager.phoneNumber
        dict["udid"] = UserDefaultsManager.udid
        dict["appVersion"] = appVersion
        dict["flight_mode"] = flightMode ? 1 : 0
        dict["battery_saving"] = batterySaving
        dict["gps_enabled"] = gpsEnabled ? 1 : 0
        dict["gps_settings"] = hasGPSPermission ? 1 : 0

        return dict
    }

    func apiCall(handler: @escaping (_ response: ReportResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: ReportResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}
