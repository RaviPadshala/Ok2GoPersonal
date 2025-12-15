//
//  MapControllerViewModel.swift
//  clock2go2020
//
//  Created by Admin on 3/24/20.
//

import UIKit
import GooglePlaces

class MapControllerViewModel {

    private var locationTitle: String?
    private var location: CLLocation

    init(locationTitle: String?, location: CLLocation) {
        self.locationTitle = locationTitle
        self.location = location
    }

    func getLocation() -> CLLocation {
        return location
    }

    func getLocationTitle() -> String {
        return locationTitle ?? ""
    }

}
