//
//  OfflineRequestEndpoint.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 19.08.2020.
//

import Alamofire

class NewOfflineRequestEndpoint: EndpointItem {


    init(action: String) {
       
        guard let endpointType = EndpointItemType(rawValue: action) else {
          let endpoint: EndpointItemType = .report
            super.init(endpointType: endpoint)
            return
        }

        let endpoint: EndpointItemType = endpointType

        super.init(endpointType: endpoint)
    }
    
    func offlineReportApiCall(_ params: Parameters, handler: @escaping (_ response: Any?, _ error: ErrorObject?) -> Void) {

        switch endpointType {
        case .report, .reportTracking:
            print("params:", params)
            apiManager.call(type: endpointType, params: params) { (response: ReportResult?, error: ErrorObject?) in
                handler(response, error)
            }
            break
        case .writeDistance:
            apiManager.call(type: endpointType, params: params) { (result: ErrorObject?, error: ErrorObject?) in
                handler(result, error)
            }
        break
        case .setAppStatus:
            apiManager.call(type: endpointType, params: params) { (result: ErrorObject?, error: ErrorObject?) in
                handler(result, error)
            }
            break
        default:
            break
        }
    }

}
