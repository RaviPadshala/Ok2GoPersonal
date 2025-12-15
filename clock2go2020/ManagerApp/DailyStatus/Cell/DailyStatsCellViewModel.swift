//
//  DailyStatsCellViewModel.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/13/20.
//

import Foundation
import UIKit

class DailyStatsDetailsCellViewModel {

    var dailyStatsDetailsObj: DailyStatsDetailsObj?

    init(dailyStatsDetailsObj: DailyStatsDetailsObj?) {
        self.dailyStatsDetailsObj = dailyStatsDetailsObj
    }

    func getDailyStatsDetailsId() -> Int {
        return dailyStatsDetailsObj?.id ?? 0
    }

    func getDailyStatsDetailsEmpName() -> String {
        return dailyStatsDetailsObj?.EmpName ?? ""
    }

    func getDailyStatsDetailsStatus() -> String {
        return dailyStatsDetailsObj?.status ?? ""
    }

    func getDailyStatsDetailsLogInTime() -> String {
        return dailyStatsDetailsObj?.timeIn ?? "--:--"
    }

    func getDailyStatsDetailsLogOutTime() -> String {
        return dailyStatsDetailsObj?.timeOut ?? "--:--"
    }

    func getIconColorByStatus() -> UIColor? {
        if dailyStatsDetailsObj?.status == "ENTRY".localized {
            return #colorLiteral(red: 0.2443430722, green: 0.800511539, blue: 0.4006313086, alpha: 1)
        }

        if dailyStatsDetailsObj?.status == "FULL".localized {
            return #colorLiteral(red: 0.1514689922, green: 0.4388672411, blue: 0.7514092326, alpha: 1)
        }

        if dailyStatsDetailsObj?.status == "NONE".localized {
            return #colorLiteral(red: 0.6731665134, green: 0.6732652783, blue: 0.673144877, alpha: 1)
        }

        if dailyStatsDetailsObj?.status == "MISS".localized {
            return #colorLiteral(red: 1, green: 0.3137254902, blue: 0.3137254902, alpha: 1)
        }

        return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
