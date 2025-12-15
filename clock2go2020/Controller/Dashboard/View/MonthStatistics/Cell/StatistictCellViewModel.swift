//
//  StatistictCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/31/20.
//

import UIKit

class StatistictCellViewModel {

    var month: MonthObj?
    var monthString: String?
    var isFirst: Bool
    var isLast: Bool
    
    let cellSize: CGSize

    init(month: MonthObj?, monthString: String?, isFirst: Bool = false, isLast: Bool = false) {
        self.month = month
        self.monthString = monthString

        self.isFirst = isFirst
        self.isLast = isLast
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let cellWidth = screenWidth > screenHeight ? screenHeight : screenWidth
        cellSize = CGSize(width: cellWidth, height: 90.0)
    }

    func getMonthString() -> String {
        if let monthString = monthString {
            return monthString + " " + "AS_OF_YESTERDAY".localized
        }
        return ""
    }

    func getMissesString() -> String {
        return month?.misses?.description ?? "0"
    }

    func getWorkingHoursString() -> String {
        return month?.workingHours?.timeFormatted() ?? "0.0"
    }

    func getVacationsString() -> String {
        return month?.vacations?.description ?? "0"
    }

    func shouldShowLeftArrow() -> Bool {
        return !isFirst
    }

    func shouldShowRightArrow() -> Bool {
        return !isLast
    }
}
