//
//  ReportsStatus.swift
//  clock2go2020
//
//  Created by Admin on 3/10/20.
//

import UIKit

enum ReportsStatus: Int {

    case automaticallyAccepted = 0 // report from the app
    case filler                = 1 // not used
    case waitingApprovemant    = 2 // manual report
    case notApproved           = 3 // manual report
    case approved              = 4 // manual report

    var icon: UIImage? {
        switch self {
            case .automaticallyAccepted:
                return nil
            case .filler:
                return nil
            case .waitingApprovemant:
                return UIImage(named: "waitingApprovemant")
            case .notApproved:
                return UIImage(named: "notApproved")
            case .approved:
                return UIImage(named: "approved")
        }
    }

}
