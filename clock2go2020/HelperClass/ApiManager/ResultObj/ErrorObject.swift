//
//  ErrorObject.swift
//  clock2go2020
//
//  Created by Admin on 1/28/20.
//

import UIKit

struct ErrorObject: Codable {
    var success: Bool = false
    var error_message: String?
    var error_code: Int?
}
