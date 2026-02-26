//
//  RequestObj+Extensions.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 19.08.2020.
//

import UIKit

extension Request {

    func set(with reportPicture: ReportPictureObj) {
        self.type = reportPicture.reportType.rawValue
        self.action = "write_picture_report"

        let location = LocationObj()
        self.lat = location.lat ?? 0
        self.lon = location.lon ?? 0
        self.accuracy = Int16(location.accuracy)

        self.taskId = reportPicture.task?.taskId
        self.remark = reportPicture.remark

        self.timestamp = Int64(NSDate().timeIntervalSince1970)

        self.attachedFile = reportPicture.attachedFiles.first?.data
    }

    func set(type: String?, taskId: String?, taskName: String?, remark: String?, locationName: Int? = nil) {
        self.type = type
        self.action = "write_report"

        let location = LocationManager.shared.getCurrentLocation()
        let lat = location?.coordinate.latitude
        let lon = location?.coordinate.longitude
        self.lat = lat ?? 0
        self.lon = lon ?? 0
        let accuracy = 16
        
        if CompaniesDataManager.shared.getClientGrpId() == 50 {
            self.trnsType = Int16(UserDefaultsManager.revachaLastLoginType)
        }else if CompaniesDataManager.shared.getClientGrpId() == 63 {
            self.trnsType = Int16(UserDefaultsManager.holocustLastLoginType - 3)
        }

        self.accuracy = Int16(accuracy)

        self.taskId = taskId
        self.taskname = taskName
        self.remark = remark
        self.locationName = Int16(locationName ?? -1000)

        self.timestamp = Int64(NSDate().timeIntervalSince1970)
    }

    func set(type: Int?, distance: Double?, accuracy: Int?) {
        self.type = String(type ?? 0)
        self.action = "write_distance"

        self.distance = distance ?? 0.0

        let location = LocationManager.shared.getCurrentLocation()
        let lat = location?.coordinate.latitude
        let lon = location?.coordinate.longitude
        self.lat = lat ?? 0
        self.lon = lon ?? 0
        let accuracy = 16

        self.accuracy = Int16(accuracy)

        self.timestamp = Int64(NSDate().timeIntervalSince1970)
    }

    func set(type: String?) {
        self.type = type
        self.action = "write_tracking"

        let location = LocationManager.shared.getCurrentLocation()
        let lat = location?.coordinate.latitude
        let lon = location?.coordinate.longitude
        self.lat = lat ?? 0
        self.lon = lon ?? 0
        let accuracy = 16

        self.accuracy = Int16(accuracy)

        self.timestamp = Int64(NSDate().timeIntervalSince1970)
    }
    
    func set(appVersion: String?, hasLocationPermission: Bool, locationEnabled: Bool, batteryLevel: Int, isFlightMode: Bool) {
        self.action = "app_status"
        self.appVersion = appVersion
        self.isLocationEnabled = locationEnabled
        self.hasLocationPermission = hasLocationPermission
        self.timestamp = Int64(NSDate().timeIntervalSince1970)
        self.batteryLevel = Int16(batteryLevel)
        self.isFlightMode = isFlightMode
    }
}
