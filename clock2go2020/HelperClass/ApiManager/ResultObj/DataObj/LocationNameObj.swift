//
//  LocationNameObj.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 15.08.2022.
//

import Foundation

struct LocationNameObj: Codable {
    let locationId: Int?
    let locationName: String?
}

extension LocationNameObj: ExtendedListInterface {
    
    func itemId() -> Int? {
        return locationId
    }
    
    func itemName() -> String {
        return locationName ?? ""
    }
}
