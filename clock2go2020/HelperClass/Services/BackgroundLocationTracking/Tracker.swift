//
//  Tracker.swift
//  clock2go2020
//
//  Created by Admin on 2/17/20.
//

import UIKit
import CoreLocation

public class TrackerController: UIViewController, CLLocationManagerDelegate {

    private var updateLocationTimer: Double = 0
    private var updateTimer: Timer?
    private var bgTask: BackgroundTaskManager!

    var latitude: Double = 0.0
    var longitude: Double = 0.0

    private var locationManager = CLLocationManager()

    func initLocationTracking(every minutes: Double) {
        self.updateLocationTimer =  minutes * 60.0
        self.startLocationManager()
        self.startLocationTracking()
        self.location_init()
    }

    func stopLocationTracking() {
        locationManager.stopUpdatingLocation()
        updateTimer?.invalidate()
    }

    public func location_init() {
        if UIApplication.shared.backgroundRefreshStatus == .denied {
            showAlert(message: "The app doesn't work without the Background App Refresh enabled. If you want to turn it on, go to Settings > General > Background App Refresh")
        } else if UIApplication.shared.backgroundRefreshStatus == .restricted {
            showAlert(message: "If you want to explore the functions of this app, you have to allow Background App Refresh.")
        } else {
            trackLocation()

            updateTimer = Timer.scheduledTimer(timeInterval: updateLocationTimer, target: self, selector: #selector(TrackerController.trackLocation), userInfo: nil, repeats: true)
        }
    }

    public func startLocationManager() {
        locationManager.delegate = self

        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }

        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    public func startLocationTracking() {
        NSLog("startLocationTracking")
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.startLocationManager()
            case .authorizedAlways, .authorizedWhenInUse:
                NSLog("authorizationStatus authorized")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
            self.startLocationManager()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitude = locations[0].coordinate.latitude
        self.longitude = locations[0].coordinate.longitude
    }

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("locationManager error:%@", error)
    }

    @objc public func trackLocation() {
        NSLog("trackLocation")
        self.updateLocationToServer()
        self.bgTask = BackgroundTaskManager().mainBackgroundTaskManager()
        _ = self.bgTask.beginNewBackgroundTask()
    }

    // MARK: private functions
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(alert, animated: true) {}
    }

    private func applicationEnterBackground() {
        self.startLocationManager()
        self.bgTask = BackgroundTaskManager().mainBackgroundTaskManager()
    }

    private func updateLocationToServer() {
        sendTrackingReport()
        NSLog("Time: %@ - Send to Server: Latitude(%f) Longitude(%f)", Date().toString(format: "HH:mm"), self.latitude, self.longitude)
    }

    func sendTrackingReport() {
        let type: ReportActionType = .trackGeolocation
        let endpointType: EndpointItemType = .reportTracking

        guard !(!ReachabilityManager.shared.hasInternetConnection) else {

            OfflineRequestsManager.sharedInstance.save(type: type.rawValue)
            NavigationController.shared?.showSuccessView(message: "OFFLINE_MODE_REPORT_SAVED".localized)

            return
        }

        let accuracy = 16

        let location = LocationManager.shared.getCurrentLocation()
        let latitude = location?.coordinate.latitude ?? 0
        let longitude = location?.coordinate.longitude ?? 0

        let report = ReportEndpoint(endpointType: endpointType, type: type, lat: latitude, lon: longitude, accuracy: accuracy, tagUID: "")
        report.apiCall { (_, error) in
            if error?.success ?? false {
                print("sendTrackingReport: success")
            } else {
                switch error?.error_code ?? 01 {
                case 500 ... 600, 1001, 2102, 01:
                    OfflineRequestsManager.sharedInstance.save(type: type.rawValue)
                    NavigationController.shared?.showSuccessView(message: "OFFLINE_MODE_REPORT_SAVED".localized)
                break
                default:
                    print("sendTrackingReport: faile")
                }

            }
        }
    }
}
