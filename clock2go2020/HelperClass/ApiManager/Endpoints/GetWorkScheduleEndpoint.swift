//
//  GetWorkScheduleEndpoint.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 08.08.2022.
//

import Alamofire

enum ScheduleWeekType: Int {
    case previous = -1
    case current = 0
    case next = 1
}

class GetWorkScheduleEndpoint: EndpointItem {
    
    private let type: ScheduleWeekType
    
    init(_ type: ScheduleWeekType) {
        self.type = type
        super.init(endpointType: .getWorkSchedule)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = [String : Any]()
        dict["action"] = endpointType.rawValue
        dict["phone"] = UserDefaultsManager.phoneNumber
        dict["udid"] = UserDefaultsManager.udid
        dict["empId"] = UserDefaultsManager.empId
        dict["week"] = type.rawValue
        
//        dict["phone"] = "0528559938"
//        dict["udid"] = "TyFmtneJgCCRO7QW"

        return dict
    }

    func apiCall(handler: @escaping (_ response: WeekWorkScheduleResponseModel?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: WeekWorkScheduleResponseModel?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}
