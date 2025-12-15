//
//  LocationObj.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 11.08.2020.
//

import Foundation
import UIKit

class LocationObj {

    var lon: Double?
    var lat: Double?
    var accuracy: Int

    init() {
        let location = LocationManager.shared.getCurrentLocation()
        lon = location?.coordinate.longitude
        lat = location?.coordinate.latitude
        accuracy = 16
    }

}
