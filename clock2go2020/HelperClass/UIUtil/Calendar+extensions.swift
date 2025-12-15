//
//  Calendar+extensions.swift
//  clock2go2020
//
//  Created by Admin on 5/1/20.
//

import UIKit

extension Calendar {

    static func getMonthLocalizedStringFor(index: Int) -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")
        return calendar.monthSymbols[index]
    }

    static func getMonthLocalizedStringBy(date: Date) -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")
        let monthIndex = calendar.component(.month, from: date)
        let monthString = calendar.monthSymbols[monthIndex-1]
        return monthString
    }

}
