//
//  AddonButtonsObj.swift
//  clock2go2020
//
//  Created by Admin on 4/15/20.
//

import UIKit

struct AddonButtonsObj: Codable {
    var button_1: AddonButtonObj?
    var button_2: AddonButtonObj?
    var button_3: AddonButtonObj?
    var button_4: AddonButtonObj?
}

struct AddonButtonObj: Codable {
    var text: String?
    var action_type: Int?
    var disable: Bool?
}
