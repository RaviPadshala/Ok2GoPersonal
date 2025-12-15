//
//  ManagerAppLoginEndpoint.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/8/20.
//

import Alamofire

class ManagerAppLoginEndpoint: EndpointItem {

    var passwd: String

    init(passwd: String) {
        self.passwd = passwd

        super.init(endpointType: .managerAppLogin)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["passwd"] = passwd
        dict["authId"] = UserDefaultsManager.empId

        return dict
    }

    func apiCall(handler: @escaping (_ response: String?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary(), disableAuthExpireLogout: true) { (result: ManagerLoginResult?, error: ErrorObject?) in
            handler(result?.data, error)
        }
    }

}
