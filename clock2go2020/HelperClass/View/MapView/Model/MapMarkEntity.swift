//
//  MapMarkEntity.swift
//  ok2go_Map
//
//  Created by MacBookPro on 2/12/20.
//
import  Foundation
import UIKit

enum MapMarkEntity: Int, CaseIterable {
    case calendar
    case place
    case clipboard
    case writing

    var icon: UIImage? {
        switch self {
        case .calendar:
            return UIImage(named: "map_calendar")
        case .place:
            return UIImage(named: "map_mapsAndFlags")
        case .clipboard:
            return UIImage(named: "map_clipboard")
        case .writing:
            return UIImage(named: "map_writing")
        }
    }

}
