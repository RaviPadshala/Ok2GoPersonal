//
//  SearchTaskResult.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 29.08.2022.
//

import Foundation

struct SearchTaskResult: Codable {
    var success: Bool?
    var data: SearchedTaskObj?
}

struct SearchedTaskObj: Codable {
    let taskId: Int
    let taskName: String
    let projectId: Int?
    let projectName: String?
}
