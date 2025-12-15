//
//  SettingsObj.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import UIKit

struct NFCMANDATORYObj: Codable {
    var NFCMandatory: Int?                 /// tasks feature active
    var NFCReportAppAutomatically: Int?               /// use last task by default or empty task
    
    
    enum CodingKeys: String, CodingKey {
        case NFCMandatory
        case NFCReportAppAutomatically
    }
}

