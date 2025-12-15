//
//  ReportEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import Alamofire

class ReportEndpoint: EndpointItem {
    

    var type: ReportActionType
    var absenceType: AbsenceTypeEntity?
    var taskId: String?
    var taskName: String?
    var remark: String?

    var files: [MediaObj?]
    var fromDate: String?
    var toDate: String?

    var lat: Double?
    var lon: Double?
    var accuracy: Int?

//    var appVersion: String?
//    var agent: String?
    var wifi: String?
    var tagUID: String?

    var empIds: [Int]?
    var extraFields: [String: Any]?
    var selectedFromCity: CitylistObj?
    var selectedToCity: CitylistObj?
    var enteredDistance: String?
    
  

    init(endpointType: EndpointItemType = .report, type: ReportActionType, absenceType: AbsenceTypeEntity? = nil, files: [MediaObj] = [], taskId: String? = nil, taskName: String? = nil, remark: String? = nil, fromDate: String? = nil, toDate: String? = nil, lat: Double? = nil, lon: Double? = nil, accuracy: Int? = nil,  wifi: String? = nil,tagUID: String?, empIds: [Int]? = nil, extraFields: [String: Any]? = nil, fromCity: CitylistObj? = nil, toCity: CitylistObj? = nil, distance: String? = nil) {

        self.taskId = taskId
        self.taskName = taskName
        self.type = type
        self.absenceType = absenceType
        self.remark = remark

        self.files = files
        self.fromDate = fromDate
        self.toDate = toDate

        self.lat = lat
        self.lon = lon
        self.accuracy = accuracy

//        self.appVersion = appVersion
//        self.agent = agent
        self.wifi = wifi
        self.tagUID = tagUID

        self.empIds = empIds
        self.extraFields = extraFields
       
        self.selectedFromCity = fromCity
        self.selectedToCity = toCity
        self.enteredDistance = distance
        
        super.init(endpointType: endpointType)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        if let absenceType = self.absenceType {
            dict["type"] = absenceType.rawValue
        } else {
            dict["type"] = type.rawValue
        }
        
      
        if fromDate != nil {
            dict["fromDate"] = fromDate
        }

        if toDate != nil {
            dict["toDate"] = toDate
        }
        
        if accuracy != nil {
            dict["accuracy"] = accuracy
        }
        
        dict["empIds"] = empIds

        if lat != nil {
            dict["lat"] = lat
        }

        if lon != nil {
            dict["lon"] = lon
        }

        if taskId != nil {
            dict["taskId"] = taskId
        }
        
        if taskName != nil {
            dict["taskName"] = taskName
        }

        if remark != nil {
            dict["remark"] = remark
        }

//        if appVersion != nil {
//            dict["appVersion"] = appVersion
//        }

        //dict["agent"] = UAString()

//        if wifi != nil {
//            dict["wifi"] = wifi
//        }

        
        
        dict["extraFields"] = extraFields
        
        if let city1 = self.selectedFromCity, let city2 = self.selectedToCity{
            var dict1 = [String: Any]()
            dict1["fromid"] = city1.ID ?? 0
            dict1["toid"] = city2.ID ?? 0
            dict["CityDistance"] = dict1
        }else if let str = self.enteredDistance, str.count > 0{
            var dict1 = [String: Any]()
            dict1["Distance"] = str
            dict["Distance"] = dict1
        }
        
        if let str = self.tagUID, str.count > 0{
            dict["serial_nfc"] = str//self.hexTo10D(hexNumber: str)
            dict["nfc"] = 1
        }else{
            dict["nfc"] = 0
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

    func apiCall(handler: @escaping (_ response: ReportResult?, _ error: ErrorObject?) -> Void) {
        
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            self.showNoInternetPopup()
            return
        }
        
        print("Request Params",convertToDictionary())
        switch endpointType {
            case .reportAbsence:
                apiManager.call(type: endpointType, imagesData: files, params: convertToDictionary()) { (response: ReportResult?, error: ErrorObject?) in
                    handler(response, error)
                }
            default:
                apiManager.call(type: endpointType, params: convertToDictionary()) { (response: ReportResult?, error: ErrorObject?) in
                    handler(response, error)
                }
        }
    }

    func showNoInternetPopup() {
        
        if isAirplaneModeOn(){
            self.showFlightModePopup()
            return
        }
        
        let alertController = UIAlertController(title: "no_internet_message_alert".localized, message: "", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve
        
        NavigationController.shared?.present(alertController, animated: true, completion: nil)
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
