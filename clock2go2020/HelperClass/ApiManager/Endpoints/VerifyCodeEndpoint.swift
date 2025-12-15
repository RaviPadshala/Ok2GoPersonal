//
//  VerifyCodeEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 1/28/20.
//

import Alamofire

class VerifyCodeEndpoint: EndpointItem {

    var verificationCode: String

    init(verificationCode: String) {
        self.verificationCode = verificationCode

        super.init(endpointType: .verifyCode)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["verificationCode"] = verificationCode

        return dict
    }

    func apiCall(handler: @escaping (_ response: VerifyResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: VerifyResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}
