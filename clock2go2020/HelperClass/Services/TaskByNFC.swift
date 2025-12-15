//
//  TaskByNFC.swift
//  clock2go2020
//
//  Created by Mac on 06/03/24.
//
import Foundation
import CoreNFC

struct TaskByNFC{
    let UID : String?
    let name : String?
    let lat : Double?
    let long : Double?
    
 
    init (UID : String, name : String?,lat:Double?,long:Double?){//,lat:String?,long:String?){
        self.UID = UID
        self.name = name
        self.lat = lat
        self.long = long
    
    }
    
//    init?(message : NFCNDEFMessage){
//        guard let taskRecord = message.records.first,
//              let taskName = taskRecord.wellKnownTypeTextPayload().0
//        else{
//            return nil
//        }
////        if taskRecord.wellKnownTypeTextPayload(){
////            
////        }
//        
////        for record in message.records {
////        if record.typeNameFormat == .nfcWellKnown {
////            // Check if the payload is text for taskId
////            if record.type == "T".data(using: .utf8) {
////                if let taskId = parseTextPayload(record: record) {
////                    print("Task ID: \(taskId)")
////                }
////            }
////            // Check if the payload is custom location data
////            else if record.type == "L".data(using: .utf8) {
////                if let (latitude, longitude) = parseLocationPayload(record: record) {
////                    print("Latitude: \(latitude), Longitude: \(longitude)")
////                }
////            }
////        }
////    }
////        if message.records.count >= 2{
////            let r  = message.records[1]
////            lat = String(r.wellKnownTypeURIPayload()
////        }
//        name = taskName
//        
//        
//       
//       
//        
//        
//        
//                
//    }
    
//    func parseTextPayload(record: NFCNDEFPayload) -> String? {
//        // Determine the text encoding (UTF-16 or UTF-8)
//        let textEncoding: String.Encoding = (record.payload.first == 0x02) ? .utf16 : .utf8
//        
//        // Determine the length of the language code
//        let languageCodeLength = Int(record.payload[0] & 0x3F)
//        
//        // The text starts after the language code
//        let textStart = 1 + languageCodeLength
//        
//        // Extract the text from the payload
//        let text = String(data: record.payload.advanced(by: textStart), encoding: textEncoding)
//        
//        return text
//    }
//    
//    func parseLocationPayload(record: NFCNDEFPayload) -> (latitude: Double, longitude: Double)? {
//        guard record.payload.count >= 16 else {
//            return nil
//        }
//        
//        let latitudeData = record.payload.subdata(in: 0..<8)
//        let longitudeData = record.payload.subdata(in: 8..<16)
//        
//        let latitude = latitudeData.withUnsafeBytes { $0.load(as: Double.self) }
//        let longitude = longitudeData.withUnsafeBytes { $0.load(as: Double.self) }
//        
//        return (latitude, longitude)
//    }
    
}
