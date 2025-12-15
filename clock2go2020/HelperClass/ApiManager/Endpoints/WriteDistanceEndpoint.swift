//
//  WriteDistanceEndpoint.swift
//  clock2go2020
//
//  Created by Admin on 4/6/20.
//

import Alamofire

class WriteDistanceEndpoint: EndpointItem {

    var type: Int
    var distance: Double?

    var lat: Double?
    var lon: Double?
    var accuracy: Int?

    //var appVersion: String?

    init(type: Int, distance: Double?, lat: Double? = nil, lon: Double? = nil, accuracy: Int? = nil) {

        self.type = type
        self.distance = distance

        self.lat = lat
        self.lon = lon
        self.accuracy = accuracy

        

        super.init(endpointType: .writeDistance)
    }

    override func convertToDictionary() -> [String: Any]? {
        var dict = super.getDefaultItems()

        dict["type"] = type
        dict["distance"] = distance

        if lat != nil {
            dict["lat"] = lat
        }

        if lon != nil {
            dict["lon"] = lon
        }

        if accuracy != nil {
            dict["accuracy"] = accuracy
        }

    
        return dict
    }

    func apiCall(handler: @escaping (_ response: ErrorObject?) -> Void) {
        apiManager.call(type: endpointType, params: convertToDictionary()) { (result: ErrorObject?, _: ErrorObject?) in
            handler(result)
        }
    }

}
