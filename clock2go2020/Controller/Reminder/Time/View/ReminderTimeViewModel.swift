//
//  ReminderTimeViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/11/20.
//

import UIKit

//enum ReminderTimeType: Int, CaseIterable {
//    case sign
//    case leave
//
//    var title: String {
//        switch self {
//            case .sign:
//                return "REMIND_SIGNIN_AT".localized
//            case .leave:
//                return "REMIND_LEAVE_AT".localized
//        }
//    }
//
//    var reminderObj: ReminderObj? {
//        switch self {
//            case .sign:
//            if let c = CompanywiseReminderHelper.shared.getCompanywiseReminder(clinetId: CompaniesDataManager.shared.getClienId() ?? 0, weekday: UserDefaultsManager.selectedDay  ?? 0, isLogin: true){
//                if let time = c.time {
//                   // return ReminderObj(time: time, isOn: true)
//                } else {
//                    return nil
//                }
//            }else{
//                return nil
//            }
////                if let time = UserDefaultsManager.loginReminderTime {
////                    return ReminderObj(time: time, isOn: true)
////                } else {
////                    return nil
////                }
//            case .leave:
//            if let c = CompanywiseReminderHelper.shared.getCompanywiseReminder(clinetId: CompaniesDataManager.shared.getClienId() ?? 0, weekday: UserDefaultsManager.selectedDay  ?? 0, isLogin: false){
//                if let time = c.time {
//                    //return ReminderObj(time: time, isOn: true)
//                } else {
//                    return nil
//                }
//            }
//            else{
//                return nil
//            }
//
//        }
//        return nil
//    }
//}

class ReminderTimeViewModel {
    
    func getNumberOfRows() -> Int {
        
        if UserDefaultsManager.selectedDay == 0{
            if let reminders = CompanywiseReminderHelper.shared.getSameReminderForEveryDay(){
                if reminders.count > 0{
                    return reminders.count
                }else{
                    let everyDayId = UUID().uuidString
                    for weekday in 1...7 {
                        CompanywiseReminderHelper.shared.addCompanywiseReminder(reminder: CompanywiseReminder(clientId: CompaniesDataManager.shared
                            .getClienId(), clientName: CompaniesDataManager.shared.getClientName(),everyDayId:everyDayId,isEveryday: true,id: UUID().uuidString, loginNotificationId: UUID().uuidString, loginTime: "" , isLogin: false, logoutNotificationId: UUID().uuidString, logoutTime: "", isLogout: false, weekday: weekday))
                    }
                    return 1
                }
            }
            
            
        }else{
            if let reminders = CompanywiseReminderHelper.shared.getCompanywiseReminder(clinetId : CompaniesDataManager.shared.getClienId() ?? 0,weekday: UserDefaultsManager.selectedDay ?? 0) {
                
                if reminders.count > 0{
                    return reminders.count
                }else{
                    CompanywiseReminderHelper.shared.addCompanywiseReminder(reminder: CompanywiseReminder(clientId: CompaniesDataManager.shared
                        .getClienId(), clientName: CompaniesDataManager.shared.getClientName(),id: UUID().uuidString, loginNotificationId: UUID().uuidString, loginTime: "" , isLogin: false, logoutNotificationId: UUID().uuidString, logoutTime: "", isLogout: false, weekday: UserDefaultsManager.selectedDay ?? 0))
                    return 1
                }
            }
        }
        return 0
    }
    
    
    func getModelFor(index: Int) -> ReminderTimeCellViewModel {
        if UserDefaultsManager.selectedDay == 0{
            return ReminderTimeCellViewModel(reminderObj: getReminderForAll(index: index), message: "REMIND_SIGNIN_AT".localized, messagelogout: "REMIND_LEAVE_AT".localized)
        }else{
            return ReminderTimeCellViewModel(reminderObj: getReminder(index: index), message: "REMIND_SIGNIN_AT".localized, messagelogout: "REMIND_LEAVE_AT".localized)
        }
        
    }
    
    func getReminderForAll(index: Int) -> ReminderObj? {
        if let reminders = CompanywiseReminderHelper.shared.getSameReminderForEveryDay(){
            return ReminderObj(time: reminders[index]?.loginTime ?? "--:--", isOn: reminders[index]?.isLogin ?? false, timeLogout: reminders[index]?.logoutTime ?? "--:--", isOnLogout: reminders[index]?.isLogout ?? false)
        }
        return nil
        
    }
    
    func getReminder(index: Int) -> ReminderObj? {
        if let reminders = CompanywiseReminderHelper.shared.getCompanywiseReminder(clinetId : CompaniesDataManager.shared.getClienId() ?? 0,weekday: UserDefaultsManager.selectedDay ?? 0) {
            return ReminderObj(time: reminders[index]?.loginTime ?? "--:--", isOn: reminders[index]?.isLogin ?? false, timeLogout: reminders[index]?.logoutTime ?? "--:--", isOnLogout: reminders[index]?.isLogout ?? false)
        }
        return nil
        
    }
    
    func getCompanywiseReminderObj(index : Int,weekday : Int)-> CompanywiseReminder?{
        if let reminders = CompanywiseReminderHelper.shared.getCompanywiseReminder(clinetId : CompaniesDataManager.shared.getClienId() ?? 0,weekday: weekday) {
            return reminders[index]
        }
        return nil
    }
    
    
    
    func updateNotification(index:Int,time : String? ,isLogin: Bool,loginOrLogoutflag: Bool){
    
        if var reminder = getCompanywiseReminderObj(index: index,weekday: UserDefaultsManager.selectedDay ?? 0) {
            if let everyday = reminder.isEveryday,everyday == true {
                if loginOrLogoutflag{
                    reminder.loginTime = isLogin ? time : "--:--"
                    reminder.isLogin = isLogin
                    if isLogin{
                        CompanywiseReminderNotificationManager.shared.removeLoginNotifications(notificationId: reminder.loginNotificationId )
                        CompanywiseReminderNotificationManager.shared.setupLoginNotification(clientName: reminder.clientName  ,time: time, weekday: UserDefaultsManager.selectedDay ?? 0, notificationId: reminder.loginNotificationId)
                    }else{
                        CompanywiseReminderNotificationManager.shared.removeLoginNotifications(notificationId: reminder.loginNotificationId )
                    }
                    CompanywiseReminderHelper.shared.updateReminderForEveryDay(reminder: reminder)
                    
                    
                }else{
                    reminder.logoutTime = isLogin ? time : "--:--"
                    reminder.isLogout = isLogin
                    if isLogin{
                        CompanywiseReminderNotificationManager.shared.removeLogoutNotifications(notificationId: reminder.logoutNotificationId )
                        CompanywiseReminderNotificationManager.shared.setupLogoutNotification(clientName: reminder.clientName  ,time: time, weekday: UserDefaultsManager.selectedDay ?? 0, notificationId: reminder.logoutNotificationId)
                    }else{
                        CompanywiseReminderNotificationManager.shared.removeLogoutNotifications(notificationId: reminder.logoutNotificationId )
                    }
                    
                    CompanywiseReminderHelper.shared.updateReminderForEveryDay(reminder: reminder)
                }
                
                
                print("Is everyday")
                
                
                
            }else{
                if loginOrLogoutflag{
                    reminder.loginTime = isLogin ? time : "--:--"
                    reminder.isLogin = isLogin
                    if isLogin{
                        CompanywiseReminderNotificationManager.shared.removeLoginNotifications(notificationId: reminder.loginNotificationId )
                        CompanywiseReminderNotificationManager.shared.setupLoginNotification(clientName: reminder.clientName  ,time: time, weekday: UserDefaultsManager.selectedDay ?? 0, notificationId: reminder.loginNotificationId)
                    }else{
                        CompanywiseReminderNotificationManager.shared.removeLoginNotifications(notificationId: reminder.loginNotificationId )
                    }
                    CompanywiseReminderHelper.shared.updateReminder(reminder: reminder)
                    
                    
                }else{
                    reminder.logoutTime = isLogin ? time : "--:--"
                    reminder.isLogout = isLogin
                    if isLogin{
                        CompanywiseReminderNotificationManager.shared.removeLogoutNotifications(notificationId: reminder.logoutNotificationId )
                        CompanywiseReminderNotificationManager.shared.setupLogoutNotification(clientName: reminder.clientName  ,time: time, weekday: UserDefaultsManager.selectedDay ?? 0, notificationId: reminder.logoutNotificationId)
                    }else{
                        CompanywiseReminderNotificationManager.shared.removeLogoutNotifications(notificationId: reminder.logoutNotificationId )
                    }
                    CompanywiseReminderHelper.shared.updateReminder(reminder: reminder)
                }
            }
        }
    }
    
    func getCompanywiseReminderObjForAll(index : Int)-> CompanywiseReminder?{
        if let reminders = CompanywiseReminderHelper.shared.getSameReminderForEveryDay(){
            return reminders[index]
        }
        return nil
    }
    
    func updateNotificationForAll(index:Int,time : String? ,isLogin: Bool,loginOrLogoutflag: Bool){
        
        if var reminder = getCompanywiseReminderObjForAll(index: index) {
            if loginOrLogoutflag{
                reminder.loginTime = isLogin ? time : "--:--"
                reminder.isLogin = isLogin
                
                if let r =  CompanywiseReminderHelper.shared.getReminderFOrEveryDay(reminder: reminder){
                    for rem in r{
                        if isLogin{
                            CompanywiseReminderNotificationManager.shared.removeLoginNotifications(notificationId: rem?.loginNotificationId )
                            CompanywiseReminderNotificationManager.shared.setupLoginNotification(clientName: rem?.clientName  ,time: time, weekday: rem?.weekday, notificationId: rem?.loginNotificationId)
                        }else{
                            CompanywiseReminderNotificationManager.shared.removeLoginNotifications(notificationId: rem?.loginNotificationId )
                        }
                    }
                }
                
                
                CompanywiseReminderHelper.shared.updateReminderForEveryDayForAll(reminder: reminder)
                
            }else{
                reminder.logoutTime = isLogin ? time : "--:--"
                reminder.isLogout = isLogin
                
                if let r =  CompanywiseReminderHelper.shared.getReminderFOrEveryDay(reminder: reminder){
                    for rem in r{
                        if isLogin{
                            CompanywiseReminderNotificationManager.shared.removeLogoutNotifications(notificationId: rem?.logoutNotificationId )
                            CompanywiseReminderNotificationManager.shared.setupLogoutNotification(clientName: rem?.clientName  ,time: time, weekday:rem?.weekday, notificationId: rem?.logoutNotificationId)
                        }else{
                            CompanywiseReminderNotificationManager.shared.removeLogoutNotifications(notificationId: rem?.logoutNotificationId )
                        }
                    }
                }
                CompanywiseReminderHelper.shared.updateReminderForEveryDayForAll(reminder: reminder)
            }
        }
    }
    
    
}
