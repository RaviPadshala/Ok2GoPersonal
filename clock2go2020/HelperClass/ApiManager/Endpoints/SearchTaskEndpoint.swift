//
//  SearchTaskEndpoint.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 26.08.2022.
//

import Alamofire

class SearchTaskEndpoint: EndpointItem {

    let searchString: String
    
    init(_ searchString: String) {
        self.searchString = searchString
        
        super.init(endpointType: .searchTask)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = [String : Any]()
        dict["action"] = endpointType.rawValue
        dict["phone"] = UserDefaultsManager.phoneNumber
        dict["udid"] = UserDefaultsManager.udid
        dict["empId"] = UserDefaultsManager.empId
        dict["search"] = searchString
        
//        dict["udid"] = "2D1Q6AFhKWBuSg0t"
//        dict["phone"] = "0528559938"

        return dict
    }

    func apiCall(handler: @escaping (_ response: SearchTaskResult?, _ error: ErrorObject?) -> Void) {
        print("convertToDictionary()", convertToDictionary())
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: SearchTaskResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}
