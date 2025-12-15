//
//  RideType.swift
//  clock2go2020
//
//  Created by Admin on 4/5/20.
//

import UIKit

enum RideType: Int, CaseIterable {
    case distance           = 1
    case publicTransport
    case fuel
    case parking

    static func withTitle(_ title: String) -> RideType? {
        return self.allCases.first { $0.title == title }
    }

    var title: String {
        switch self {
            case .distance:
                return "Distance in km"
            case .publicTransport:
                return "Public transport"
            case .fuel:
                return "Fuel"
            case .parking:
                return "Parking"
        }
    }

    var image: UIImage? {
        switch self {
            default:
                return UIImage(named: "car8")
        }
    }

    var valueType: RideValueType {
        switch self {
            case .distance:
                return .distance
            case .publicTransport, .fuel, .parking:
                return .price
        }
    }

    var valueTitle: String {
        return valueType.title
    }

    var valueImage: UIImage? {
        return valueType.image
    }

    var canAttachFile: Bool {
        switch self {
            case .distance:
                return false
            case .publicTransport, .fuel, .parking:
                return true
        }
    }

    static func allTitles() -> [String] {
        var titles: [String] = []

        for type in RideType.allCases {
            titles.append(type.title)
        }

        return titles
    }
}

enum RideValueType {
    case price
    case distance

    var title: String {
        switch self {
            case .price:
                return "Enter a price"
            case .distance:
                return "Enter distance"
        }
    }

    var image: UIImage? {
        switch self {
            case .price:
                return UIImage(named: "price")
            case .distance:
                return UIImage(named: "location")
        }
    }
}
