//
//  LocationManager.swift
//

import UIKit
import CoreLocation
import GooglePlaces

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private var manager = CLLocationManager()
    
    private var backgroundTask = UIBackgroundTaskIdentifier.invalid
    
    // MARK: - Completion
    
    private var locationCompletion: ((CLLocation?, Error?) -> Void)?
    
    // MARK: - Init
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        
        requestLocationPermissions()
    }
    
    // MARK: - Start Monitoring
    
    func startMonitoring() {
        
        manager.delegate = self
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 50.0
        
        manager.startUpdatingLocation()
        
        if #available(iOS 11.0, *) {
            manager.showsBackgroundLocationIndicator = false
        }
    }
    
    // MARK: - Request Fresh Location
    
    func requestFreshLocation(completion: @escaping (CLLocation?, Error?) -> Void) {
        
        self.locationCompletion = completion
        
        guard CLLocationManager.locationServicesEnabled() else {
            
            completion(nil, NSError(
                domain: "",
                code: 1000,
                userInfo: [
                    NSLocalizedDescriptionKey: "Location service disabled"
                ]
            ))
            
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        guard status == .authorizedAlways ||
                status == .authorizedWhenInUse else {
            
            requestLocationPermissions()
            
            completion(nil, NSError(
                domain: "",
                code: 1001,
                userInfo: [
                    NSLocalizedDescriptionKey: "Location permission denied"
                ]
            ))
            
            return
        }
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request fresh GPS update
        manager.requestLocation()
    }
    
    // MARK: - Permission
    
    func requestLocationPermissions() {
        
        manager.requestWhenInUseAuthorization()
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Authorized")
            
        case .restricted, .denied:
            print("Location Denied")
            getAlertController()
            
        case .notDetermined:
            break
            
        @unknown default:
            break
        }
    }
    
    func hasPermission() -> Bool {
        
        let status = CLLocationManager.authorizationStatus()
        
        return status == .authorizedAlways ||
        status == .authorizedWhenInUse
    }
    
    func isLocationEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return manager.location
    }
    
    // MARK: - Alert
    
    func getAlertController() {
        
        let alertController = UIAlertController(
            title: "LOCATION_REQUEST_TITLE".localized,
            message: "LOCATION_REQUSET_SUBTITLE".localized,
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(
            title: "SETTINGS".localized,
            style: .default
        ) { _ in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "CANCEL".localized,
            style: .default
        )
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve
        
        NavigationController.shared?.present(
            alertController,
            animated: true
        )
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("Authorization Status Changed : \(status.rawValue)")
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            
            locationCompletion?(nil, NSError(
                domain: "",
                code: 1002,
                userInfo: [
                    NSLocalizedDescriptionKey: "Unable to fetch location"
                ]
            ))
            
            return
        }
        
        // MARK: - Check Cached / Old Location
        
        let locationAge = abs(location.timestamp.timeIntervalSinceNow)
        
        print("Location Age :", locationAge)
        
        // Reject if older than 2 minutes
        if locationAge > 120 {
            
            locationCompletion?(nil, NSError(
                domain: "",
                code: 1003,
                userInfo: [
                    NSLocalizedDescriptionKey: "Old cached location detected. Please try again."
                ]
            ))
            
            return
        }
        
        // MARK: - Accuracy Validation
        
        print("Accuracy :", location.horizontalAccuracy)
        
        if location.horizontalAccuracy < 0 ||
            location.horizontalAccuracy > 100 {
            
            locationCompletion?(nil, NSError(
                domain: "",
                code: 1004,
                userInfo: [
                    NSLocalizedDescriptionKey: "Poor GPS accuracy. Please move near open area or window."
                ]
            ))
            
            return
        }
        
        // MARK: - Success
        
        print("Fresh Location Received")
        print("Latitude :", location.coordinate.latitude)
        print("Longitude :", location.coordinate.longitude)
        
        locationCompletion?(location, nil)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
        print("Location Error :", error.localizedDescription)
        
        locationCompletion?(nil, error)
    }
}

extension CLLocationDegrees {
    
    func toString() -> String {
        return "\(self)"
    }
    
}
