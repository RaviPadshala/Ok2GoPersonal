//
//  GetRevachaEventTypesEndpoint.swift
//  clock2go2020
//
//  Created by Gleb on 28.05.2021.
//

import Foundation
import Alamofire

class GetRevachaEventTypesEndpoint: EndpointItem {
    
    var taskId: Int?
    
    init(taskId:Int) {
        self.taskId = taskId
        
        super.init(endpointType: .getRevachaEventTypes)
    }
    
    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["taskId"] = taskId
    
        return dict
    }
    
  
    func apiCall(handler: @escaping (_ response:GetRevachaEventTypesResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: GetRevachaEventTypesResult?, error: ErrorObject?) in
            handler(result , error)
        }
    }
}
