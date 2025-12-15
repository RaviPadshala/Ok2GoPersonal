//
//  ReminderTimeCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/23/20.
//

import UIKit

class ReminderTimeCellViewModel: NSObject {

    var reminderObj: ReminderObj?
    var messageTitle: String
    var messageLogoutTitle: String

    init(reminderObj: ReminderObj?, message: String?, messagelogout: String?) {
        self.reminderObj = reminderObj
        self.messageTitle = message ?? ""
        self.messageLogoutTitle = messagelogout ?? ""
    }

    func getMessageTitle() -> String {
        return messageTitle
    }

    func getTimeString() -> String {
        if reminderObj?.time == "" || reminderObj?.time == nil{
            return "--:--"
        }
        return reminderObj?.time ?? "--:--"
    }

    func getSwitchedMode() -> Bool {
        return reminderObj?.isOn ?? false
    }
    
    
    func getMessageLogoutTitle() -> String {
        return messageLogoutTitle
    }

    func getLogoutTimeString() -> String {
        if reminderObj?.timeLogout == "" || reminderObj?.timeLogout == nil{
            return "--:--"
        }
        return reminderObj?.timeLogout ?? "--:--"
    }

    func getLogoutSwitchedMode() -> Bool {
        return reminderObj?.isOnLogout ?? false
    }


}
