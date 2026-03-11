//
//  UserDefaultsManager.swift
//  clock2go2020
//
//  Created by Admin on 12/27/19.
//

import UIKit

let kSampleDictArray = "sampleDictArray"
let kAppleLanguages = "AppleLanguages"
let kPhoneNumber = "PhoneNumber"
let kUDID = "udid"
let kEmpId = "empId"
let kImage = "image"
let kSelectedDaysToReminder = "reminderDays"
let kLoginReminder = "loginReminder"
let kLogoutReminder = "logoutReminder"
let kClientId = "clientId"
let kIsLoginCheck = "LoginCheck"
let kIsNFCCheck = "nfcCheck"


let kMultiLoginEmps = "multiLoginEmps"
let kMultiLoginTask = "multiLoginTask"

let kGetCompaniesRequestDate = "getCompaniesRequestDate"

let kCashedCompanies = "cachedCompanies"

// Manager settings
/// checking when user on manager screen for SideBar(Mgr My reports)
let kManagerAppActivity  = "enabledManagerApp"
/// date from filter for monthEmpReport and closeMonthReport filter
let kDateValueMgrReport  = "dateValueMgrReport"
/// empId from employeesReport  for monthEmpReport
let kEmpIdMgrReport      = "empIdMgrReport"
/// checking if the user was logged in as a manager at least once
let kUserLoggedInManager = "userLoggedInManager"
/// save OneSignal userId
let kUserIdOneSignal = "oneSignalUserId"
/// save value for update get_companies after updateApp
let kAppVersion = "ppVersion"
/// lastDistance
let kLastDistance = "lastDistance"
/// connection service count
let kConnectionServiceCount = "connectionServiceCount"
/// last  transaction type revacha login
let kRevachaLastLoginType = "revachaLastLoginType"
/// last  transaction type holocust login
let kHolocustLastLoginType = "holocustLastLoginType"
/// last  transaction type holocust theraphy type
let kHolocustLastLoginTheraphyType = "holocustLastLoginTheraphyType"
///last user's email on closeMonthVIew
let kLastEnteredEmail = "lastEmail"

let kReminderObject = "CompanywiseReminder"

let kSelectedDay = "SelectedDayForReminder"

class UserDefaultsManager: NSObject {
    
    
    //For NFC
    class var isLogin: Bool? {
        set { set(newValue, for: kIsLoginCheck, shouldClear: false) }
        get { return getValue(forKey: kIsLoginCheck) as? Bool ?? false  }
    }
//    class var isLogin: String? {
//        set { set(newValue, for: kIsLoginCheck, shouldClear: false) }
//        get { return getValue(forKey: kIsLoginCheck) as? String ?? ""  }
//    }
    class var isNFCCheck: Bool {
        set { set(newValue, for: kIsNFCCheck, shouldClear: false) }
        get { return getValue(forKey: kIsNFCCheck) as? Bool ?? false  }
    }

    class var lastEmailCloseMonth: String {
        set { set(newValue, for: kLastEnteredEmail, shouldClear: false) }
        get { return getValue(forKey: kLastEnteredEmail) as? String ?? ""  }
    }
    
    class var revachaLastLoginType: Int {
        set { set(newValue, for: kRevachaLastLoginType, shouldClear: false) }
        get { return getValue(forKey: kRevachaLastLoginType) as? Int ?? 1  }
    }
    
    class var holocustLastLoginType: Int {
        set { set(newValue, for: kHolocustLastLoginType, shouldClear: false) }
        get { return getValue(forKey: kHolocustLastLoginType) as? Int ?? 6  }
    }
    
    class var holocustLastTheraphyType: Int {
        set { set(newValue, for: kHolocustLastLoginTheraphyType, shouldClear: false) }
        get { return getValue(forKey: kHolocustLastLoginTheraphyType) as? Int ?? 1  }
    }

    class var connectionServiceCount: Int {
        set { set(newValue, for: kConnectionServiceCount, shouldClear: false) }
        get { return getValue(forKey: kConnectionServiceCount) as? Int ?? 1  }
    }

    class var lastUserDistance: Double? {
        set { set(newValue, for: kLastDistance, shouldClear: false) }
        get { return getValue(forKey: kLastDistance) as? Double ?? 0.0 }
    }

    class var appVersion: String {
        set { set(newValue, for: kAppVersion, shouldClear: false) }
        get { return getValue(forKey: kAppVersion) as? String ?? "1.0.0"  }
    }

    class var oneSignalUserId: String? {
        set { set(newValue, for: kUserIdOneSignal, shouldClear: false) }
        get { return getValue(forKey: kUserIdOneSignal) as? String ?? "" }
    }
    class var appleLanguage: String? {
        set { set(newValue, for: "appleLanguage", shouldClear: false) }
        get { return getValue(forKey: "appleLanguage") as? String ?? "" }
    }

    class var appleLanguages: [String] {
        set { set(newValue, for: kAppleLanguages, shouldClear: false) }
        get { return getValue(forKey: kAppleLanguages) as? [String] ?? []}
    }
    class var appleLanguagesNew: [String] {
        set { set(newValue, for: "appleLanguagesNew", shouldClear: false) }
        get { return getValue(forKey: "appleLanguagesNew") as? [String] ?? [] }
    }

    class var isManagerApp: Bool {
        set { set(newValue, for: kManagerAppActivity, shouldClear: false) }
        get { return getValue(forKey: kManagerAppActivity) as? Bool ?? false  }
    }

    class var userLoggedInManager: Bool {
        set { set(newValue, for: kUserLoggedInManager, shouldClear: false) }
        get { return getValue(forKey: kUserLoggedInManager) as? Bool ?? false  }
    }

    class var dateMgrReport: Date {
        set { set(newValue, for: kDateValueMgrReport, shouldClear: false) }
        get { return getValue(forKey: kDateValueMgrReport) as? Date ?? Date()}
    }
    class var empIdMgrReport: Int {
        set { set(newValue, for: kEmpIdMgrReport, shouldClear: false) }
        get { return getValue(forKey: kEmpIdMgrReport) as? Int ?? 0  }
    }

    class var phoneNumber: String? {
        set { set(newValue, for: kPhoneNumber, shouldClear: false) }
        get { return getValue(forKey: kPhoneNumber) as? String }
    }

    class var udid: String? {
        set { set(newValue, for: kUDID, shouldClear: false) }
        get { return getValue(forKey: kUDID) as? String }
    }

    class var empId: Int? {
        set { set(newValue, for: kEmpId, shouldClear: false) }
        get { return getValue(forKey: kEmpId) as? Int }
    }

    class var clientId: Int? {
        set { set(newValue, for: kClientId, shouldClear: false) }
        get { return getValue(forKey: kClientId) as? Int }
    }

    class var image: Data? {
        set { set(newValue, for: kImage, shouldClear: false) }
        get { return getValue(forKey: kImage) as? Data }
    }

    class var reminderDays: [Int]? {
        set { set(newValue, for: kSelectedDaysToReminder, shouldClear: false) }
        get { return getValue(forKey: kSelectedDaysToReminder) as? [Int] }
    }

    class var loginReminderTime: String? {
        set { set(newValue, for: kLoginReminder, shouldClear: false) }
        get { return getValue(forKey: kLoginReminder) as? String }
    }

    class var logoutReminderTime: String? {
        set { set(newValue, for: kLogoutReminder, shouldClear: false) }
        get { return getValue(forKey: kLogoutReminder) as? String }
    }

    class var multiLoginEmps: [Int]? {
        set { set(newValue, for: kMultiLoginEmps, shouldClear: false) }
        get { return getValue(forKey: kMultiLoginEmps) as? [Int] }
    }

    class var multiLoginTask: String? {
        set { set(newValue, for: kMultiLoginTask, shouldClear: false) }
        get { return getValue(forKey: kMultiLoginTask) as? String }
    }

    class var getCompaniesRequestDate: Date? {
        set { set(newValue, for: kGetCompaniesRequestDate, shouldClear: false) }
        get { return getValue(forKey: kGetCompaniesRequestDate) as? Date }
    }

    class var companiesObj: [CompanyObj]? {
        set {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(newValue)
                UserDefaultsManager.set(data, for: kCashedCompanies)
            } catch {
                 print("Unable to encode object into data")
            }
        }
        get {
            guard let data = UserDefaultsManager.getValue(forKey: kCashedCompanies) as? Data else {
                print("No data object found for the given key")
                return nil
            }
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode([CompanyObj]?.self, from: data)
                return object
            } catch {
                print("Unable to decode object into given type")
                return nil

            }
        }
    }
    class var selectedDay: Int? {
        set { set(newValue, for: kSelectedDay, shouldClear: false) }
        get { return getValue(forKey: kSelectedDay) as? Int }
    }
    
    class var companiesReminderObj: [CompanywiseReminder]? {
        set {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(newValue)
                UserDefaultsManager.set(data, for: kReminderObject)
            } catch {
                 print("Unable to encode object into data")
            }
        }
        get {
            guard let data = UserDefaultsManager.getValue(forKey: kReminderObject) as? Data else {
                print("No data object found for the given key")
                return nil
            }
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode([CompanywiseReminder]?.self, from: data)
                return object
            } catch {
                print("Unable to decode object into given type")
                return nil

            }
        }
    }
    
    
    // set/fetch offline report
    class var sampleDictArray: [[String: Any]]? {
        
        set {
            setDictionaryArray(newValue, forKey: kSampleDictArray)
        }
        
        get {
            return getDictionaryArray(forKey: kSampleDictArray)
        }
    }
    
    // store offline report
    class func setDictionaryArray(_ array: [[String: Any]]?, forKey key: String) {
        
        guard let array = array else {
            remove(for: key)
            return
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            set(data, for: key, shouldClear: false)
        } catch {
            print("Failed to save dictionary array:", error)
        }
    }
    
    // get offline report
    class func getDictionaryArray(forKey key: String) -> [[String: Any]]? {
        
        guard let data = getValue(forKey: key) as? Data else {
            return nil
        }
        
        do {
            let array = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            return array
        } catch {
            print("Failed to fetch dictionary array:", error)
            return nil
        }
    }

   class func getValue(forKey key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }

    class func set(_ object: Any?, for key: String, shouldClear: Bool = true) {
        if object != nil {
            userDefaults.set(object, forKey: key)
            UserDefaultsManager.add(key: key, should: shouldClear)
            userDefaults.synchronize()
        } else {
            remove(for: key)
        }
    }

    class func remove(for key: String) {
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
        removeKey(key: key)
    }

    /**
     clear the keys added by UserDefaultsManager and set 'shouldClear : true'
     */
    class func clear() {
        if let keys = UserDefaultsManager.getKeys() {
            for key in keys {
                if key.value {
                    remove(for: key.key)
                }
            }
        }
    }

    /**
     clear all the keys added by UserDefaultsManager
     */
    class func resetAll() {
        if let keys = UserDefaultsManager.getKeys() {
            for key in keys {
                remove(for: key.key)
            }
        }
    }

    private class var userDefaults: UserDefaults {
        return UserDefaults.standard
    }

    private class func getKeys() -> [String: Bool]? {
        let oldkeys = userDefaults.dictionaryRepresentation().keys
        var keys = [
            "appleLanguagesNew" : false
           // kAppleLanguages: false
        ]
        for key in oldkeys {
            if !(keys.keys.contains(key)) {
                keys[key] = true
            }
        }
        return keys
    }

    private class func add(key: String, should clear: Bool) {
        if var keys = getKeys() {
            keys[key] = clear
        }
    }

    private class func removeKey(key: String) {
        if var keys = getKeys() {
            keys.removeValue(forKey: key)
        }
    }

}
// Protocol for CUSTOME object savable
protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }

    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"

    var errorDescription: String? {
        rawValue
    }
}
