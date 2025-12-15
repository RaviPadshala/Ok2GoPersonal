//
//  SampleReportResult.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 24.08.2022.
//

import UIKit

struct SampleReportResult: Codable {
    let success: Bool?
    let data: SampleReportObj?
}

struct SampleReportObj: Codable {
    let address: String?
    let polygon: String?
}


