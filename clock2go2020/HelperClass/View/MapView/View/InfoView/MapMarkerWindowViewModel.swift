//
//  MapMarkerWindowViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/25/20.
//

import UIKit

class MapMarkerWindowViewModel: NSObject {

    var reportObj: ReportObj?

    init(reportObj: ReportObj?) {
        self.reportObj = reportObj
    }

    func getValueForRow(row: Int) -> String {
        guard let mapMarkEntity = MapMarkEntity.init(rawValue: row) else { return "-" }
        switch mapMarkEntity {
            case .calendar:
                return String(reportObj?.time.prefix(5) ?? "-")
            case .place:
                return reportObj?.location ?? "-"
            case .clipboard:
                return reportObj?.taskName ?? "-"
            case .writing:
                return reportObj?.remark ?? "-"
        }
    }

    func getStatusColor() -> UIColor {
        let type = reportObj?.actionType ?? "1"

        if type == "1" {
            return #colorLiteral(red: 0.2443430722, green: 0.800511539, blue: 0.4006313086, alpha: 1)
        } else if type == "2" {
            return #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 1)
        } else if type == "98" {
            return #colorLiteral(red: 0.9773489833, green: 0.4326385856, blue: 0.8032094836, alpha: 1)
        } else if type == "99" {
            return #colorLiteral(red: 0.9866847396, green: 0.7379429936, blue: 0.9088150859, alpha: 1)
        } else {
            return #colorLiteral(red: 0, green: 1, blue: 0.8470588235, alpha: 1)
        }
    }

    func getStatusTitle() -> String {
        let type = reportObj?.actionType ?? "1"

        if type == "1" {
            return "LOGIN".localized
        } else if type == "2" {
            return "LOGOUT".localized
        } else if type == "98" {
            return "PAUSE".localized
        } else if type == "99" {
            return "END_PAUSE".localized
        } else {
            return ""
        }
    }
}
