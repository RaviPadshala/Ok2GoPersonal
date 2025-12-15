//
//  TypeCircularView.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/16/20.
//

import UIKit

enum typeCircle: String {

    case miss
    case full
    case none
    case entry

    var color: UIColor? {
        switch self {
            case .miss:
                return #colorLiteral(red: 1, green: 0.3137254902, blue: 0.3137254902, alpha: 1)
            case .full:
                return #colorLiteral(red: 0.1514689922, green: 0.4388672411, blue: 0.7514092326, alpha: 1)
            case .none:
                return #colorLiteral(red: 0.6731665134, green: 0.6732652783, blue: 0.673144877, alpha: 1)
            case .entry:
                return #colorLiteral(red: 0.2443430722, green: 0.800511539, blue: 0.4006313086, alpha: 1)
        }
    }

    var title: String {
        switch self {
            case .miss:
                return "MISS".localized
            case .full:
                return "FULL".localized
            case .none:
                return "NONE".localized
            case .entry:
                return "ENTRY".localized
        }
    }
}
