//
//  ReportEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import Alamofire

class CheckNFCEndPoint: EndpointItem {
    
    var tagUID: String?
    
    init(tagUID: String?) {

        self.tagUID = tagUID
        
        super.init(endpointType: .getNFC)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        if let str = self.tagUID, str.count > 0{
            dict["serial_nfc"] = str//self.hexTo10D(hexNumber: str)
        }

        return dict
    }
    
    func hexTo10D(hexNumber: String) -> String {
        // Remove any colons and convert to uppercase
        let cleanHex = hexNumber.replacingOccurrences(of: ":", with: "").uppercased()

        // Convert the hex string to an integer
        if let decimalValue = Int(cleanHex, radix: 16) {
            // Format the decimal value as a 10-digit string
            return String(format: "%010d", decimalValue)
        } else {
            // Return an empty string or handle the error as needed
            return ""
        }
    }

    func apiCall(handler: @escaping (_ response: CheckNFCResult?, _ error: ErrorObject?) -> Void) {
        
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            self.showNoInternetPopup()
            return
        }
        
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: CheckNFCResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

    func showNoInternetPopup() {
        
//        if isAirplaneModeOn(){
//            self.showFlightModePopup()
//            return
//        }
        
        isAirplaneModeOnNew { isAirplane in
            if isAirplane {
                self.showFlightModePopup()
                return
            }else{
                let alertController = UIAlertController(title: "no_internet_message_alert".localized, message: "", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                alertController.addAction(settingsAction)
                alertController.modalPresentationStyle = .overCurrentContext
                alertController.modalTransitionStyle = .crossDissolve
                
                NavigationController.shared?.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func showFlightModePopup() {
        let alertController = UIAlertController(title: "airplane_mode_turned_off_message_alert".localized, message: "", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "SETTINGS".localized, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: "App-Prefs:root=AIRPLANE_MODE") else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve
        
        NavigationController.shared?.present(alertController, animated: true, completion: nil)
    }
}
