//
//  GetDisclaimerEndpoint.swift
//

import Alamofire

enum DisclaimerTypes: Int {
    case reportDisclaimer = 1
    case trackingDisclaimer = 2
}

class GetDisclaimerEndpoint: EndpointItem {
    
    let disclaimerType: DisclaimerTypes
    let language: String

    init(disclaimerType: DisclaimerTypes, language: String) {
        
        self.disclaimerType = disclaimerType
        self.language = language

        super.init(endpointType: .getDisclaimer)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        dict["disclaimerType"] = self.disclaimerType.rawValue
        dict["lang"] = self.language

        return dict
    }

    func apiCall(handler: @escaping (_ response: GetDisclaimerResult?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: GetDisclaimerResult?, error: ErrorObject?) in
            handler(response, error)
        }
    }

}

