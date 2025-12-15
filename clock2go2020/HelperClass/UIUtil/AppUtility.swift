//
//  AppUtility.swift
//  clock2go2020
//
//  Created by Admin on 3/10/20.
//

import UIKit

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

    /// Get current language code of the device
    static func getCurrentLanguageCode() -> String {
        return NSLocale.current.languageCode ?? "en"
    }
    
    static func getConfirmationAlertWith(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "YES".localized, style: .default) { action in
            //
        }
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "NO".localized, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(noAction)
        
        return alert
    }
    
    static func getAlertWith(title: String?, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ok".localized, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        return alert
    }
}

func delay(durationInSeconds seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
