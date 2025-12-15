//
//  FormDataobj.swift
//  clock2go2020
//
//  Created by Mac on 26/09/24.
//

import Foundation

struct FormData: Codable {
    let url: String?
    let conditions: Conditions?
    let formName: String?
    
    let taskId : String?
    
    enum CodingKeys: String,CodingKey{
        case url
        case conditions
        case formName
        
        case taskId = "TaskId"
    }
}


struct Conditions: Codable {
    let mandatoryBeforeReport: Int?
   
    let showInAllReports: ShowInAllReports?
    let showInMyForms: Int?
    let attachToReport: Int?
    
    enum CodingKeys: String, CodingKey {
        case mandatoryBeforeReport = "MandatoryBeforeReport"
       
        case showInAllReports = "ShowInAllReports"
        case showInMyForms = "ShowInMyForms"
        case attachToReport = "AttachToReport"
    }
}

struct ShowInAllReports: Codable {
    let enter: String?
    let exit: String?
    let enterService: String?
    let exitService: String?
    
    enum CodingKeys: String, CodingKey {
        case enter = "ENTER"
        case exit = "EXIT"
        case enterService = "ENTER_SERVICE"
        case exitService = "EXIT_SERVICE"
    }
}

