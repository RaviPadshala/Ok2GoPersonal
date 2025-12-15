//
//  LocationManager.swift
//  clock2go2020
//
//  Created by Admin on 2/26/20.
//

import UIKit
import GooglePlaces

class LocationManager: NSObject {

    static let shared = LocationManager()

    private var manager = CLLocationManager()

    private var backgroundTask = UIBackgroundTaskIdentifier.invalid
    
    
    
//    var addressString = ""
//    let geocoder = CLGeocoder()
//    var locality = ""
//    var administrativeArea = ""
//    var country = ""

    override init() {
        super.init()

        manager.delegate = self
        requestLocationPermissions()
    }

    func startMonitoring() {
        manager.delegate = self
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 100.0
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        if #available(iOS 11.0, *) {
            manager.showsBackgroundLocationIndicator = false
        }

    }
    
    func getAlertController() {
        // initialise a pop up for using later
        let alertController = UIAlertController(title: "LOCATION_REQUEST_TITLE".localized, message: "LOCATION_REQUSET_SUBTITLE".localized, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "SETTINGS".localized, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
             }
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve

        NavigationController.shared?.present(alertController, animated: true, completion: nil)
    }
    func requestLocationPermissions() {
        manager.requestWhenInUseAuthorization()

        // check the permission status
        switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorize.")
           
                // get the user location
            case .restricted, .denied:
                // redirect the users to settings
          
                print("NOT Authorize.")
                getAlertController()
        case .notDetermined:
            
            break
        @unknown default: 
            
            break

        }
        print("request Location Permissions")
    }

    func getCurrentLocation() -> CLLocation? {
        if manager.location != nil {
            return manager.location
        } else {
            let pluginLocation = DistanceMeasurementManager.shared.getCurrentPosition()
            return pluginLocation
        }
    }

    func shouldReportLocation() -> Bool {
        return true
    }

    func hasPermission() -> Bool {
        let status = CLLocationManager.authorizationStatus()

        if status == .authorizedWhenInUse || status == .authorizedAlways {
           
            return true
        } else {
           
            requestLocationPermissions()
            return false
        }
    }
    
    func isLocationEnabled()  -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    func postCurrentlocation() {
        let status = CLLocationManager.authorizationStatus()

        if status == .authorizedAlways {
            postLocation(location: manager.location)
        } else {
            requestLocationPermissions()
        }
    }
    
    // MARK: - Private functions
    @objc private func askLocationPermissionForAlways() {
        let status = CLLocationManager.authorizationStatus()
        if status != .notDetermined && status != .denied && status != .restricted && status != .authorizedAlways && status == .authorizedWhenInUse {
            print("request location access for always")
            manager.requestAlwaysAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")

        switch status {
        case .authorizedAlways:
           
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            
            print("user allow app to get location data only when app is active")
            askLocationPermissionForAlways()
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        @unknown default:
            fatalError()
        }

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }

        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if  let location = locations[0] as CLLocation?{
//            
//            
//            // manager.stopUpdatingLocation()
//            
//           geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
//                if (error != nil) {
//                    print("Error in reverseGeocode")
//                }
//                
//                if let place = placemarks  {
//               // let place = placemarks! as [CLPlacemark]
//                    
//                    if place.count > 0 {
//                        let place = placemarks![0]
//                        
//                        if place.thoroughfare != nil {
//                            self.addressString = self.addressString + place.thoroughfare! + ", "
//                        }
//                        if place.subThoroughfare != nil {
//                            self.addressString = self.addressString + place.subThoroughfare! + ", "
//                        }
//                        if place.locality != nil {
//                            self.addressString = self.addressString + place.locality! + ", "
//                        }
//                        if place.postalCode != nil {
//                            self.addressString = self.addressString + place.postalCode! + ", "
//                        }
//                        
//                        if place.country != nil {
//                            self.addressString = self.addressString + place.country!
//                        }
//                    }
//                }
//            })
//        }
    }
    
 

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension LocationManager {
    private func postLocation(location: CLLocation?) {
        guard let location = location else { return }

        if UIApplication.shared.applicationState == .background {

            backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "send_Location", expirationHandler: {
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskIdentifier.invalid
            })

            DispatchQueue.global(qos: .background).async {
                self.postRequest(location: location) { [weak self] in
                    guard let self = self else { return }
                    UIApplication.shared.endBackgroundTask(self.backgroundTask)
                    self.backgroundTask = UIBackgroundTaskIdentifier.invalid
                }
            }
        } else {
            postRequest(location: location)
        }
    }

    private func postRequest(location: CLLocation, completion: (() -> Void)? = nil) {
        // TODO Send Post
        print("postRequest: " + String(describing: location.coordinate) + " date: " + Date().description )
    }
}

extension CLLocationDegrees {

 func toString() -> String {
      return "\(self)"
   }
}
