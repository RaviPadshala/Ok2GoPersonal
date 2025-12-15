//
//  RevachaEventObj.swift
//  clock2go2020
//
//  Created by Gleb on 28.05.2021.
//

import Foundation

struct RevachaEventObj: Codable {
    var eventType: String?
    var eventName: String?
}

struct CitylistObj: Codable {
    var ID: Int?
    var city: String?
}

struct TherapyeventTypesObj: Codable {
    var TransType: String?
    var TherapyName: String?
    var TherapyType: String?
    var EventType: String?
}
