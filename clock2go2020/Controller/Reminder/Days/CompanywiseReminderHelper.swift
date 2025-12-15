//
//  CompanywiseReminderHelper.swift
//  clock2go2020
//
//  Created by Mac on 18/07/24.
//

import Foundation

protocol CompanywiseReminderHelperProtocol{
    
    func getCompanywiseReminder(clinetId clientId : Int ,weekday : Int) -> [CompanywiseReminder?]?
    func addCompanywiseReminder(reminder : CompanywiseReminder)
    
}

class CompanywiseReminderHelper : CompanywiseReminderHelperProtocol{
    
    static let shared = CompanywiseReminderHelper()
    
    func getCompanywiseReminder(clinetId clientId : Int ,weekday : Int) -> [CompanywiseReminder?]? {
        
        if let companies = UserDefaultsManager.companiesReminderObj {
            return companies.filter({$0.clientId == clientId && $0.weekday == weekday})
        }
        return []
    }
    func getCompanywiseReminderForAll(clinetId clientId : Int ) -> [CompanywiseReminder?]? {
        
        if let companies = UserDefaultsManager.companiesReminderObj {
            return companies.filter({$0.clientId == clientId })
        }
        return []
    }
    
    func getCompanywiseReminderForAllDaysHasSameReminder(clinetId clientId : Int) -> [CompanywiseReminder?]? {
        guard let comapnies = getCompanywiseReminderForAll(clinetId: CompaniesDataManager.shared.getClienId() ?? 0) else{return nil}
        var reminder : [CompanywiseReminder?]? = []
        let sundayReminders = comapnies.filter({$0?.weekday == 1})
        for (_,sunday) in sundayReminders.enumerated(){
            for monday in comapnies.filter({$0?.weekday == 2}){
                if monday?.loginTime == sunday?.loginTime && monday?.logoutTime == sunday?.logoutTime{
                    for tuesday in comapnies.filter({$0?.weekday == 3}){
                        if sunday?.loginTime == tuesday?.loginTime && sunday?.logoutTime == tuesday?.logoutTime{
                            for wednesday in comapnies.filter({$0?.weekday == 4}){
                                if sunday?.loginTime == wednesday?.loginTime && sunday?.logoutTime == wednesday?.logoutTime{
                                    for thursday in comapnies.filter({$0?.weekday == 5}){
                                        if sunday?.loginTime == thursday?.loginTime && sunday?.logoutTime == thursday?.logoutTime{
                                            for friday in comapnies.filter({$0?.weekday == 6}){
                                                if sunday?.loginTime == friday?.loginTime && sunday?.logoutTime == friday?.logoutTime{
                                                    for saturday in comapnies.filter({$0?.weekday == 7}){
                                                        if sunday?.loginTime == saturday?.loginTime && sunday?.logoutTime == saturday?.logoutTime{
                                                            reminder?.append(saturday)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return reminder
    }
    
    func getSameReminderForEveryDay()-> [CompanywiseReminder?]? {
        
        guard let comapnies = getCompanywiseReminderForAll(clinetId: CompaniesDataManager.shared.getClienId() ?? 0) else{return nil}
        var reminder : [CompanywiseReminder?]? = []
        let filterArr = comapnies.filter({$0?.everyDayId != nil})
        if filterArr.count > 0{
            let arr = filterArr.map({$0?.everyDayId})
            print("arrrrrr", arr)
            let sundayReminders = filterArr.filter({$0?.weekday == 1})
            for (_,sunday) in sundayReminders.enumerated(){
                for monday in filterArr.filter({$0?.weekday == 2}){
                    if monday?.everyDayId == sunday?.everyDayId {
                        for tuesday in filterArr.filter({$0?.weekday == 3}){
                            if sunday?.everyDayId == tuesday?.everyDayId {
                                for wednesday in filterArr.filter({$0?.weekday == 4}){
                                    if sunday?.everyDayId == wednesday?.everyDayId {
                                        for thursday in filterArr.filter({$0?.weekday == 5}){
                                            if sunday?.everyDayId == thursday?.everyDayId {
                                                for friday in filterArr.filter({$0?.weekday == 6}){
                                                    if sunday?.everyDayId == friday?.everyDayId {
                                                        for saturday in filterArr.filter({$0?.weekday == 7}){
                                                            if sunday?.everyDayId == saturday?.everyDayId {
                                                                reminder?.append(saturday)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return reminder
    }
    
    func addCompanywiseReminder(reminder : CompanywiseReminder) {
        if var companies = UserDefaultsManager.companiesReminderObj {
            companies.append(reminder)
            UserDefaultsManager.companiesReminderObj = companies
        }else{
            let com = [reminder]
            UserDefaultsManager.companiesReminderObj = com
        }
        
    }
    
    func isAlreadyReminder(clinetId clientId : Int ,weekday : Int,isLogin : Bool) -> Bool{
        if let companies = UserDefaultsManager.companiesReminderObj {
            if companies.contains(obj: getCompanywiseReminder(clinetId: clientId, weekday: weekday)){
                return true
            }else{
                return false
            }
        }
        return false
        
    }
    
    func updateReminder(reminder : CompanywiseReminder?){
        if var companies = UserDefaultsManager.companiesReminderObj, let r = reminder{
            if let index = companies.firstIndex(where: {$0.id! == r.id}){
                companies[index] = r
                UserDefaultsManager.companiesReminderObj = companies
            }
            
//            for (index,companywiseReminder) in companies.enumerated(){
//                if let r = reminder{
//                    if (r.id == companywiseReminder.id){
//                        companies[index] = r
//                        UserDefaultsManager.companiesReminderObj = companies
//                    }
//                }
//            }
        }
    }
    
    func updateReminderForEveryDay(reminder : CompanywiseReminder?){
        if var companies = UserDefaultsManager.companiesReminderObj, let r = reminder{
            
            for (index,companywiseReminder) in companies.enumerated(){
                if r.id == companywiseReminder.id{
                    companies[index] = r
                    UserDefaultsManager.companiesReminderObj = companies
                }
                if let e = r.everyDayId, e == companywiseReminder.everyDayId{
                    companies[index].isEveryday = false
                    companies[index].everyDayId = nil
                    UserDefaultsManager.companiesReminderObj = companies
                }
            }
        }
    }
    
    func updateReminderForEveryDayForAll(reminder : CompanywiseReminder?){
        if var companies = UserDefaultsManager.companiesReminderObj{
            for (index,companywiseReminder) in companies.enumerated(){
                if let r = reminder{
                    if r.everyDayId == companywiseReminder.everyDayId{
                        companies[index].loginTime = r.loginTime
                        companies[index].isLogin = r.isLogin
                        companies[index].logoutTime = r.logoutTime
                        companies[index].isLogout = r.isLogout
                        UserDefaultsManager.companiesReminderObj = companies
                    }
                }
            }
        }
    }
    
    func getReminderFOrEveryDay(reminder : CompanywiseReminder?) -> [CompanywiseReminder?]?{
        guard let comapnies = getCompanywiseReminderForAll(clinetId: CompaniesDataManager.shared.getClienId() ?? 0) else{return nil}
        var rem : [CompanywiseReminder?]? = []
        for r in comapnies{
            if r?.everyDayId == reminder?.everyDayId{
                rem?.append(r)
            }
        }
        
        return rem
    }
    func deleteReminderforAll(clinetId clientId : Int ) {
        if var companies = UserDefaultsManager.companiesReminderObj {
            for reminder in companies{
                if (clientId == reminder.clientId ){
                    if ((reminder.loginTime == "--:--" || reminder.loginTime == "" || reminder.loginTime == nil ) && (reminder.logoutTime == "--:--" || reminder.logoutTime == "" || reminder.logoutTime == nil ) ){
                        companies.removeObject(object: reminder)
                        UserDefaultsManager.companiesReminderObj = companies
                    }
                }
            }
        }
    }
    
    func deleteReminder(clinetId clientId : Int ,weekday : Int) {
        if var companies = UserDefaultsManager.companiesReminderObj {
            for reminder in companies{
                if (clientId == reminder.clientId && weekday == reminder.weekday){
                    if ((reminder.loginTime == "--:--" || reminder.loginTime == "" || reminder.loginTime == nil ) && (reminder.logoutTime == "--:--" || reminder.logoutTime == "" || reminder.logoutTime == nil ) ){
                        companies.removeObject(object: reminder)
                        UserDefaultsManager.companiesReminderObj = companies
                    }
                }
            }
        }
    }
    
    
    func checkIfdayHasReminder(clientId: Int, weekday: Int) -> Bool{
        if let companies = UserDefaultsManager.companiesReminderObj {
            for companywiseReminder in companies{
                if (clientId == companywiseReminder.clientId && weekday == companywiseReminder.weekday ){
                    if !hasEmptyTime(time: companywiseReminder.loginTime) || !hasEmptyTime(time: companywiseReminder.logoutTime) {
                        return true
                    }
                    
                }
            }
        }
        return false
    }
    
    func checkIfdayHasReminderForAll() -> Bool{
        
        if let reminders = getSameReminderForEveryDay(){
            if reminders.count > 0{
                return true
            }else{
                return false
            }
            
        }
        return false
    }
    
    func checkIfdayHasSameEmptyReminderForAll() -> Bool{
        
        if let reminders = getCompanywiseReminderForAllDaysHasSameReminder(clinetId:CompaniesDataManager.shared.getClienId() ?? 0){
            for reminder in reminders {
                if hasEmptyTime(time: reminder?.loginTime) && hasEmptyTime(time: reminder?.logoutTime) {
                    return true
                }
            }
        }
        return false
    }
    
    
    func checkIfAllDayHasSameReminder(clientId: Int) -> [ReminderObj?]?{
        guard let comapnies = getCompanywiseReminderForAll(clinetId: CompaniesDataManager.shared.getClienId() ?? 0) else{return nil}
        var reminder : [ReminderObj?]? = []
        var sundayReminders = comapnies.filter({$0?.weekday == 1})
        for (index,sunday) in sundayReminders.enumerated(){
            for monday in comapnies.filter({$0?.weekday == 2}){
                if monday?.loginTime == sunday?.loginTime && monday?.logoutTime == sunday?.logoutTime{
                    for tuesday in comapnies.filter({$0?.weekday == 3}){
                        if sunday?.loginTime == tuesday?.loginTime && sunday?.logoutTime == tuesday?.logoutTime{
                            for wednesday in comapnies.filter({$0?.weekday == 4}){
                                if sunday?.loginTime == wednesday?.loginTime && sunday?.logoutTime == wednesday?.logoutTime{
                                    for thursday in comapnies.filter({$0?.weekday == 5}){
                                        if sunday?.loginTime == thursday?.loginTime && sunday?.logoutTime == thursday?.logoutTime{
                                            for friday in comapnies.filter({$0?.weekday == 6}){
                                                if sunday?.loginTime == friday?.loginTime && sunday?.logoutTime == friday?.logoutTime{
                                                    for saturday in comapnies.filter({$0?.weekday == 7}){
                                                        if sunday?.loginTime == saturday?.loginTime && sunday?.logoutTime == saturday?.logoutTime{
                                                            reminder?.append(ReminderObj(time: saturday?.loginTime ?? "--:--", isOn: saturday?.isLogin ?? false, timeLogout: saturday?.logoutTime ?? "--:--", isOnLogout: saturday?.isLogout ?? false))
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return reminder
        
        
    }
    
    
    
    func checkIfdayHasReminderIsEmpty() -> Bool{
        if let clientId = CompaniesDataManager.shared.getClienId(), let weekday = UserDefaultsManager.selectedDay {
            if let companies = UserDefaultsManager.companiesReminderObj {
                for companywiseReminder in companies{
                    if (clientId == companywiseReminder.clientId && weekday == companywiseReminder.weekday ){
                        if hasEmptyTime(time: companywiseReminder.loginTime) && hasEmptyTime(time: companywiseReminder.logoutTime){
                            return true
                        }
                    }
                }
                
            }
        }
        return false
    }
    
    
    
    func hasEmptyTime(time : String?) -> Bool{
        if (time == "--:--" || time == "" || time == nil )  {
            return true
        }
        
        return false
    }
    
}

extension Dictionary {
    func distinctByKey(_ predicate: (Key) -> Bool) -> [Key: Value] {
        var result = [Key: Value]()
        for (key, value) in self where predicate(key) {
            result[key] = value
        }
        return result
    }
}
