//
//  GetAbsencePicturesEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 3/29/20.
//

import Alamofire

class GetAbsencePicturesEndpoint: EndpointItem {

    var date: String?
    var type: Int?

    init(date: String?, type: Int?) {
        self.date = date
        self.type = type

        super.init(endpointType: .getAbsencePics)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        if date != nil {
            dict["date"] = date
        }

        if type != nil {
            dict["type"] = type
        }

        return dict
    }

    func apiCall(handler: @escaping (_ response: [AbsencePictureObj]?, _ error: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: AbsencePicturesResult?, error: ErrorObject?) in
            handler(response?.data, error)
        }
    }

}
