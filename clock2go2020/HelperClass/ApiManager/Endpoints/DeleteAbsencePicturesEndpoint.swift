//
//  DeleteAbsencePicturesEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 3/29/20.
//

import Alamofire

class DeleteAbsencePicturesEndpoint: EndpointItem {

    var date: String?
    var type: Int?
    var filename: String?

    init(date: String?, type: Int?, filename: String?) {
        self.date = date
        self.type = type
        self.filename = filename

        super.init(endpointType: .deleteAbsencePic)
    }

    override func convertToDictionary() -> Parameters? {
        var dict = super.getDefaultItems()

        if date != nil {
            dict["date"] = date
        }

        if type != nil {
            dict["type"] = type
        }

        if filename != nil {
            dict["filename"] = filename
        }

        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (response: ErrorObject?, _: ErrorObject?) in
            handler(response)
        }
    }

}
