//
//  CompanywiseReminderNotificationManager.swift
//  clock2go2020
//
//  Created by Mac on 18/07/24.
//

import UIKit
import UserNotifications

class CompanywiseReminderNotificationManager {

    static let shared = CompanywiseReminderNotificationManager()

    let loginNotificationIdentifier = "LoginNotification"
    let logoutNotificationIdentifier = "LogoutNotification"

    func getReminderDays() -> [Int] {
        return UserDefaultsManager.reminderDays ?? [1, 2, 3, 4, 5]
    }

    func scheduleNotification(at dateComponents: DateComponents, body: String, titles: String, identifier: String, completion: @escaping (Bool) -> Void) {

        // Create Notification trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Create Notification content
        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = identifier

        // Create a notification request with the above components
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Add this notification to the UserNotificationCenter
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    private func get24HourTimeWith(string: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        var reminderDate: Date?
        
        if let date = dateFormatter.date(from: string) {
            reminderDate = date
        }else {
            dateFormatter.dateFormat = "HH:mm"
            if let date = dateFormatter.date(from: string) {
                reminderDate = date
            }
        }

        guard let date = reminderDate else {
            return nil
        }
        dateFormatter.dateFormat = "HH:mm"

        let time24 = dateFormatter.string(from: date)
        return time24
    }
    
    func setupLoginNotification(clientName: String?,time : String?,weekday: Int?, notificationId : String?) {
        if let reminderTime = time,
           let time24Hour = self.get24HourTimeWith(string: reminderTime),
           let hour = Int(time24Hour.prefix(2)),
           let minute = Int(time24Hour.suffix(2)),let weekday = weekday,let identifier = notificationId {

            let dateComponents = getDateComponents(weekday: weekday, hour: hour, minute: minute)
            scheduleNotification(at: dateComponents, body: "LOGIN_REMINDER_TEXT".localized  , titles: clientName ?? "LOGIN_REMINDER_TITLE".localized, identifier: identifier) { (success) in
                    if success {
                        print("Login Successfully scheduled notification for \(clientName!):  " + identifier )
                    } else {
                        print("Error scheduling notification: " + identifier)
                    }
                }
        }

    }

    func removeLoginNotifications(notificationId: String?) {
        if let identifier = notificationId{
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
            print("Remove notifications =\(identifier)")
        }
       
    }
    


    func setupLogoutNotification(clientName: String?,time : String?,weekday: Int?, notificationId : String?) {
        if let reminderTime = time,
           let time24Hour = self.get24HourTimeWith(string: reminderTime),
           let hour = Int(time24Hour.prefix(2)),
           let minute = Int(time24Hour.suffix(2)),let weekday = weekday,let identifier = notificationId {
  
            let dateComponents = getDateComponents(weekday: weekday, hour: hour, minute: minute)
//                scheduleNotification(at: dateComponents, body: "LOGOUT_REMINDER_TEXT".localized, titles: "LOGOUT_REMINDER_TITLE".localized, identifier: identifier) { (success) in
                    scheduleNotification(at: dateComponents, body: "LOGOUT_REMINDER_TEXT".localized, titles: clientName ?? "LOGOUT_REMINDER_TITLE".localized, identifier: identifier) { (success) in
                    if success {
                        print("Logout Successfully scheduled notification: for \(clientName!): " + identifier)
                    } else {
                        print("Error scheduling notification: " + identifier)
                    }
                }
            
        }
    }

    func removeLogoutNotifications(notificationId: String?) {
        if let identifier = notificationId{
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
            //print("Remove notifications =\(identifier)")
        }
    }
    
    func removeAllPendingNotificationsFromLocal(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
//    func setupLoginNotification(time : String?,weekday: Int?, notificationId : String?) {
//        if let reminderTime = time,
//           let time24Hour = self.get24HourTimeWith(string: reminderTime),
//           let hour = Int(time24Hour.prefix(2)),
//           let minute = Int(time24Hour.suffix(2)),let weekday = weekday,let identifier = notificationId {
//        
//               
//
//            let dateComponents = getDateComponents(weekday: weekday, hour: hour, minute: minute)
//                scheduleNotification(at: dateComponents, body: "LOGIN_REMINDER_TEXT".localized, titles: "LOGIN_REMINDER_TITLE".localized, identifier: identifier) { (success) in
//                    if success {
//                        print("Successfully scheduled notification: " + identifier )
//                    } else {
//                        print("Error scheduling notification: " + identifier)
//                    }
//                }
//            
////            for weekday in reminderDays {
////                if weekday == 0 {
////                    continue
////                }
////
////                let identifier = loginNotificationIdentifier + String(weekday)
////
////                let dateComponents = getDateComponents(weekday: weekday, hour: hour, minute: minute)
////                scheduleNotification(at: dateComponents, body: "LOGIN_REMINDER_TEXT".localized, titles: "LOGIN_REMINDER_TITLE".localized, identifier: identifier) { (success) in
////                    if success {
////                        print("Successfully scheduled notification: " + identifier)
////                    } else {
////                        print("Error scheduling notification: " + identifier)
////                    }
////                }
////            }
//        }
//
//    }
//    
    
    //    func removeLoginNotifications() {
    //        if let reminderDays = UserDefaultsManager.reminderDays {
    //            let center = UNUserNotificationCenter.current()
    //            for weekday in reminderDays {
    //                if weekday == 0 {
    //                    continue
    //                }
    //                let identifier = loginNotificationIdentifier + String(weekday)
    //                center.removePendingNotificationRequests(withIdentifiers: [identifier])
    //            }
    //        }
    //    }
    
//    func setupLogoutNotification() {
//        if let reminderTime = UserDefaultsManager.logoutReminderTime,
//           let time24Hour = self.get24HourTimeWith(string: reminderTime),
//           let hour = Int(time24Hour.prefix(2)),
//           let minute = Int(time24Hour.suffix(2)) {
//            let reminderDays = getReminderDays()
//
//            for weekday in reminderDays {
//                if weekday == 0 {
//                    continue
//                }
//
//                let identifier = logoutNotificationIdentifier + String(weekday)
//
//                let dateComponents = getDateComponents(weekday: weekday, hour: hour, minute: minute)
//                scheduleNotification(at: dateComponents, body: "LOGOUT_REMINDER_TEXT".localized, titles: "LOGOUT_REMINDER_TITLE".localized, identifier: identifier) { (success) in
//                    if success {
//                        print("Successfully scheduled notification: " + identifier)
//                    } else {
//                        print("Error scheduling notification: " + identifier)
//                    }
//                }
//            }
//        }
//    }
//
//    func removeLogoutNotifications() {
//        if let reminderDays = UserDefaultsManager.reminderDays {
//            let center = UNUserNotificationCenter.current()
//            for weekday in reminderDays {
//                if weekday == 0 {
//                    continue
//                }
//                let identifier = logoutNotificationIdentifier + String(weekday)
//                center.removePendingNotificationRequests(withIdentifiers: [identifier])
//            }
//        }
//    }

    func getDateComponents(weekday: Int, hour: Int, minute: Int) -> DateComponents {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.weekday = weekday // sunday = 1 ... saturday = 7

        return components
    }

    func distanceMeasurementNotification(title: String, body: String) {
        // Create Notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        // Create Notification trigger
        let request = UNNotificationRequest(identifier: "distanceMesuarement", content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
