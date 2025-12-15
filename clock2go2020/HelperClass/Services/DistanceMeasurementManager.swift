//
//  DistanceMeasurementManager.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/6/20.
//

import Foundation
import TSLocationManager
import TSBackgroundFetch

class DistanceMeasurementManager {

    // MARK: - Static property
    static let shared = DistanceMeasurementManager()
    var  distance = 0.0

    // MARK: - Public method
    func start() {
//        //Reset distance before start ride
//        TSLocationManager.sharedInstance()?.destroyLocations()
//        TSLocationManager.sharedInstance()?.setOdometer(0, request: TSCurrentPositionRequest())
//        
//        //plugin settings
//        let config = TSConfig.sharedInstance()
//        
//        ///config parameters
//        config?.update({ builder in
//            ///When enabled, the plugin will emit sounds & notifications for life-cycle events of background-geolocation
//            builder?.debug = false
//            ///Specify the desired-accuracy of the geolocation system.
//            builder?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//            ///Sets the verbosity of the plugin's logs
//            builder?.logLevel = TSLogLevel(0)
//            ///Set to YES to enable background-tracking after the device reboots.
//            builder?.startOnBoot = true
//            ///Set NO to continue tracking after user teminates the app.
//            builder?.stopOnTerminate = false
//            ///The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
//            builder?.distanceFilter = 50
//            ///When stopped, the minimum distance the device must move beyond the stationary location for aggressive background-tracking to engage.
//            ///min 200m
//            builder?.stationaryRadius = 50
//            ///The number of minutes to wait before turning off location-services after the ActivityRecognition System (ARS) detects the device is STILL
//            builder?.stopTimeout = 60
//            ///Location accuracy threshold in meters for odometer calculations.
//            builder?.desiredOdometerAccuracy = 25
//            ///A BOOL indicating whether the status bar changes its appearance when an app uses location services in the background with Always authorization.
//            builder?.showsBackgroundLocationIndicator = true
//            //Number of minute to delay the stop-detection system from being activated. Default is no delay.
//            builder?.stopDetectionDelay = 20
//            builder?.heartbeatInterval = 60
//            builder?.preventSuspend = true
//            builder?.activityRecognitionInterval = 0
//        })
//        
//        //Events
//        ///get distance
//        TSLocationManager.sharedInstance()?.onLocation({ location in
//            if let to = location?.toDictionary() {
//                print("[location] \(to)")
//                guard let meters = TSConfig.sharedInstance()?.odometer else {return}
//                UserDefaultsManager.lastUserDistance = meters
//                if meters > 1000 && (meters - self.distance) > 1000 {
//                    self.distance = meters
//                    ReminderNotificationManager.shared.distanceMeasurementNotification(title: "DISTANCE_MEASUREMENT".localized,
//                                                                                       body: "\("DISTANCE".localized) \(round(meters)) \("METERS".localized)\n")
//                }
//               
//
//                print("\n\n\n\n\n\n\n\n\n\n \( String(describing: UserDefaultsManager.lastUserDistance)) \n\n\n\n\n\n\n\n\n\n\n")
//            }
//        }, failure: { error in
//            print("[location] error \(NSNumber(value: (error as NSError?)?.code ?? 0))")
//        })
//        
//        let bgGeo = TSLocationManager.sharedInstance()
//        ///Signal to the plugin that  app is booted and ready
//        bgGeo?.ready()
//        
//        if TSConfig.sharedInstance()?.enabled == false {
//            ///Signal to the plugin that your app is booted and ready
//            TSLocationManager.sharedInstance()?.start()
//        }
    }

    func stop() {
        /// Disable location & geofence tracking
        TSLocationManager.sharedInstance()?.stop()
        UserDefaultsManager.lastUserDistance  = TSConfig.sharedInstance()?.odometer
        print("\n\n\n\n\n\n\n\n\n\n \( String(describing: UserDefaultsManager.lastUserDistance)) \n\n\n\n\n\n\n\n\n\n\n")
    }

    func getDistanceInMeters() -> Double? {
        guard let meters =  TSConfig.sharedInstance()?.odometer else { return nil }
        return round(meters )
    }

    func getCurrentPosition() -> CLLocation? {
        /// Accept the last-recorded-location if no older than supplied value in milliseconds.
        TSCurrentPositionRequest().maximumAge = 0
        /// Defaults to YES. Set NO to disable persisting the retrieved location in the plugin's SQLite database.
        TSCurrentPositionRequest().persist = true
        /// Sets the maximum number of location-samples to fetch. The plugin will return the location having the best accuracy to your successFn. Defaults to 3. Only the final location will be persisted.
        TSCurrentPositionRequest().samples = 1
        /// [stationaryRadius] Sets the desired accuracy of location you're attempting to fetch.
        TSCurrentPositionRequest().desiredAccuracy = 0
        /// Execute Request
        TSLocationManager.sharedInstance().getCurrentPosition(TSCurrentPositionRequest())
        return TSLocationManager.sharedInstance()?.locationManager.location
    }
}
