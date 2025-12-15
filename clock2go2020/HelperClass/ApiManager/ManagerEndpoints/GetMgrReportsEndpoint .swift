//
//  GetMgrReports .swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Foundation
import Alamofire

class GetMgrReportsEndpoint: EndpointItem {

    var month: String?

    init(month: String) {
        self.month = month

        super.init(endpointType: .getMgrReports )
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["token"] = ManagerAppDataManager.shared.getManagerToken()
        dict["month"] = month

        return dict
    }

    func apiCall(handler: @escaping (_ response: GetMgrReportsResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: GetMgrReportsResult?, error: ErrorObject?) in
            handler(result, error)
        }
    }

}
