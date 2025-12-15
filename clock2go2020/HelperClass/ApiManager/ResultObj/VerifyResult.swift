//
//  VerifyResult.swift
//  clock2go2020
//
//  Created by Admin on 1/28/20.
//

import UIKit

struct VerifyResult: Codable {

    var success: Bool?

    struct Data: Codable {
        var udid: String
    }

    var data: Data
}
