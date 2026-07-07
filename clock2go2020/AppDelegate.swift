//
//  AppDelegate.swift
//  clock2go2020
//
//  Created by Admin on 12/11/19.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications
import OneSignal
import Firebase
import TSBackgroundFetch
import TSLocationManager
import Network
import netfox
import CoreLocation

// Attendance security kit imports
// Files are in Security/AttendanceSecurityKit.swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let monitor = NWPathMonitor()
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait
    let locationValidator = LocationValidator()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
       
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
       

        ReachabilityManager.shared.start()
        self.initOneSignal(launchOptions: launchOptions)
        
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            self.window?.makeKeyAndVisible()
        }

        if UserDefaultsManager.appleLanguagesNew.count == 0 || (LanguageEntity.withIdentifier(UserDefaultsManager.appleLanguagesNew.first ?? "") == nil) {
            if let deviceLanguage = Locale.preferredLanguages.first, let _ = LanguageEntity.withIdentifier(String(deviceLanguage.prefix(2))) {
                UserDefaultsManager.appleLanguagesNew = [String(deviceLanguage.prefix(2))]
            } else {
                UserDefaultsManager.appleLanguagesNew = ["en"]
            }
        }

        self.initGoogleMapsKeys()

        UNUserNotificationCenter.current().delegate = self

        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.error)

        if #available(iOS 15.0, *) {
            // Warm up location permission and validate linkage to AttendanceSecurityKit
            Task { [weak self] in
                let approvedBSSIDs: Set<String> = [] // configure if you have company Wi‑Fi anchors
                do {
                    _ = try await self?.locationValidator.currentValidatedLocation(approvedBSSIDs: approvedBSSIDs)
                    print("[AttendanceSecurity] Location validation ready.")
                } catch {
                    print("[AttendanceSecurity] Location validation error: \(error)")
                }
            }
        }

        // Disable log
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        /// when app is close reset when user was logged in maagerApp
        UserDefaultsManager.userLoggedInManager = false

        let dashbordViewModel = DashboardViewModel()
        dashbordViewModel.checkLastUserDistance()
        dashbordViewModel.sendAppStatusInfo()

        TSBackgroundFetch.sharedInstance().didFinishLaunching()

        monitor.pathUpdateHandler = { path in
            if path.availableInterfaces.count == 0 {
                print("\n\nFLight mode!\n\n")
                UserDefaultsManager.connectionServiceCount = 0
            } else {
                UserDefaultsManager.connectionServiceCount = path.availableInterfaces.count
                print("\n\nNo flight mode.\n\n")
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        /// when app is close reset when user was logged in maagerApp
        UserDefaultsManager.userLoggedInManager = false
        /// save last user distance
        guard let distance = TSConfig.sharedInstance()?.odometer else {return}
        if  distance > 0 {
            UserDefaultsManager.lastUserDistance = distance
            ReminderNotificationManager.shared.distanceMeasurementNotification(title: "END_RIDE".localized,
                                                                               body: "\("DISTANCE".localized) \(round(distance)) \("METERS".localized)\n")
            TSLocationManager.sharedInstance()?.stop()
            print("\n\\n\n\n\n\n \( String(describing: UserDefaultsManager.lastUserDistance)) n\n\n\n\n\n")
        }
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        // NotificationCenter.default.post(name: Notification.Name(rawValue: "PushNotificationRecieved"), object: self, userInfo: nil)

        completionHandler(.alert)
    }

    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

}

// Google Maps
extension AppDelegate {
    private func initGoogleMapsKeys() {
        // API Key
        GMSServices.provideAPIKey("AIzaSyA5KwTwhLP75E-Jy5BBxCbTiJ09-4dbta0")
        GMSPlacesClient.provideAPIKey("AIzaSyA5KwTwhLP75E-Jy5BBxCbTiJ09-4dbta0")
        CLLocationManager.authorizationStatus()
    }
}

// OneSignal
extension AppDelegate: OSSubscriptionObserver, OSPermissionObserver {

    private func initOneSignal(launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let notificationReceivedBlock = oneSignalnotificationReceived()
        let notificationOpenedBlock = oneSignalnotificationOpened()

        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.add(self as OSSubscriptionObserver)
        OneSignal.add(self as OSPermissionObserver)
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "1e630e27-7995-487e-8ea4-776a6aa2d091",
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //
    }

    private func oneSignalnotificationReceived() -> OSHandleNotificationReceivedBlock {
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in

            NotificationCenter.default.post(name: Notification.Name(rawValue: "PushNotificationRecieved"), object: self, userInfo: nil)

            print("Received Notification: \(String(describing: notification!.payload.notificationID))")
        }

        return notificationReceivedBlock
    }

    private func oneSignalnotificationOpened() -> OSHandleNotificationActionBlock {
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let notificationId: String = result!.notification.payload.notificationID
            PushNotificationManager.sharedInstance.setRead(notificationId: notificationId)

            if let notification = PushNotificationManager.sharedInstance.fetch(PushNotification.self, notificationId: notificationId).first {

                NotificationCenter.default.post(name: Notification.Name(rawValue: "PushNotificationRecieved"), object: self, userInfo: nil)

                let vc = ViewSource.dashboardScreen()
                vc.viewModel.setNotification(notification: notification)

                NavigationController.shared?.setRoot(vc, animated: false)
            }
        }

        return notificationOpenedBlock
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        print("\(#line) - OneSignal Permissions Enabled: \(OneSignal.getPermissionSubscriptionState()?.subscriptionStatus.subscribed ?? false)")
        // The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            UserDefaultsManager.oneSignalUserId = playerId
        }
    }

    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        print("\(#line) - OneSignal Permissions Enabled: \(OneSignal.getPermissionSubscriptionState()?.permissionStatus.status == .authorized)")
    }
}
extension AppDelegate {
    //BACKGROUND FETCH
    func perform(completionHandler handler: ((UIBackgroundFetchResult) -> Void)!, applicationState state: UIApplication.State){
        
    }
}

