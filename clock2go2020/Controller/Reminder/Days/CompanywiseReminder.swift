//
//  CompanywiseReminder.swift
//  clock2go2020
//
//  Created by Mac on 17/07/24.
//

import Foundation

struct CompanywiseReminder : Codable,Equatable{
    
    var clientId  : Int?
    var clientName : String?
    var everyDayId : String?
    var isEveryday :Bool?
    var id: String?
    var loginNotificationId : String?
    var loginTime : String?
    var isLogin : Bool?
    var logoutNotificationId : String?
    var logoutTime : String?
    var isLogout : Bool?
    var weekday : Int?
    
}


