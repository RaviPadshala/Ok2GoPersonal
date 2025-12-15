//
//  ReminderDaysViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/11/20.
//

import UIKit

enum ReminderDaysType: Int, CaseIterable {
    case allDays    = 0
    case sundays    = 1
    case mondays    = 2
    case tuesday    = 3
    case wednesdays = 4
    case thursdays  = 5
    case fridays    = 6
    case saturdays  = 7

    var title: String {
        switch self {
            case .allDays:
                return "ALL_DAYS".localized
            case .sundays:
                return "Sunday".localized
            case .mondays:
                return "Monday".localized
            case .tuesday:
                return "Tuesday".localized
            case .wednesdays:
                return "Wednesday".localized
            case .thursdays:
                return "Thursday".localized
            case .fridays:
                return "Friday".localized
            case .saturdays:
                return "Saturday".localized
        }
    }
    
//    var title: String {
//        switch self {
//            case .allDays:
//                return "ALL_DAYS".localized
//            case .sundays:
//                return "ALL_SUNDAYS".localized
//            case .mondays:
//                return "ALL_MODAYS".localized
//            case .tuesday:
//                return "ALL_TUESDAYS".localized
//            case .wednesdays:
//                return "ALL_WEDNESDAYS".localized
//            case .thursdays:
//                return "ALL_THURSDAYS".localized
//            case .fridays:
//                return "ALL_FRIDAYS".localized
//            case .saturdays:
//                return "ALL_SATURDAYS".localized
//        }
//    }
}

class ReminderDaysViewModel {

    var selectedDays: [Int]

    init() {
        selectedDays = UserDefaultsManager.reminderDays ?? [1, 2, 3, 4, 5]
    }

    func getSelectedDays() -> [Int] {
        return selectedDays
    }

    func getNumberOfRows() -> Int {
        return ReminderDaysType.allCases.count
    }

    func getModelFor(index: Int) -> ReminderDaysCellViewModel {
        let isSelected = isSelectedDay(index: index)
        return ReminderDaysCellViewModel(type: ReminderDaysType(rawValue: index)!, isSelected: isSelected)
    }

    func changeDaySelection(index: Int) {
        if index == 0 {
            if selectedDays.contains(index) {
                selectedDays.removeAll()
            } else {
                selectedDays = [0, 1, 2, 3, 4, 5, 6, 7]
            }

        } else {
            if let selectedIndex = selectedDays.firstIndex(of: index) {
                selectedDays.remove(at: selectedIndex)
            } else {
                selectedDays.append(index)
            }
        }
    }

    func isSelectedDay(index: Int) -> Bool {
        //return selectedDays.contains(index)
        if index == 0{
            return CompanywiseReminderHelper.shared.checkIfdayHasReminderForAll()
        }
        return CompanywiseReminderHelper.shared.checkIfdayHasReminder(clientId: CompaniesDataManager.shared.getClienId() ?? 0, weekday: index)
    }
    
    

    func saveNewSelectedDays() {
        // remove old reminders
        ReminderNotificationManager.shared.removeLoginNotifications()
        ReminderNotificationManager.shared.removeLogoutNotifications()

        // save new selected days for reminders
        UserDefaultsManager.reminderDays = selectedDays

        // set new reminders
        ReminderNotificationManager.shared.setupLoginNotification()
        ReminderNotificationManager.shared.setupLogoutNotification()

        // returns to user profile screen
        NavigationController.shared?.popViewControllers(viewsToPop: 2)
    }
}
