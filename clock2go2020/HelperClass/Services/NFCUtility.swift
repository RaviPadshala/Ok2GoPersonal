//
//  NFCUtility.swift
//  clock2go2020
//
//  Created by Mac on 06/03/24.
//


import Foundation
import CoreNFC
import UserNotifications

typealias NFCReadingCmpletion = (Result<NFCNDEFMessage?,Error>) -> Void
typealias TaskReadingByNFCCompletion = (Result<TaskByNFC, Error>) -> Void

enum NFCError : LocalizedError{
    case unavailable
    case invalidated(message : String)
    case invalidatedPayloadSize
    
    var errorDescription: String?{
        switch self{
        case .unavailable:
            return "NFC_Reader_not_available".localized
        case .invalidated(let message):
            return  message
        case  .invalidatedPayloadSize:
            return "NDEF exceeds the payload size limit"
            
        }
    }
}

class NFCUtility : NSObject{
    
    enum NFCAction{
        
        case readTaskByNFC
        //        case setupLocation(locationName : String)
        //        case addVisitor(visitorName : String)
        
        
        var alertMessage : String{
            switch self{
            case .readTaskByNFC :
                return "Scan_the_sticker_with_your_phone_to_make_a_report".localized
                
                
            }
        }
    }
    
    private static let shared = NFCUtility()
    private var action : NFCAction = .readTaskByNFC
    
    private var sessionNFCNDEF : NFCNDEFReaderSession?
    private var completion : TaskReadingByNFCCompletion?
    
    var nfcSession: NFCTagReaderSession?
    
    static func performAction(_ action : NFCAction,completion : TaskReadingByNFCCompletion? = nil){
        
        guard NFCNDEFReaderSession.readingAvailable else{
            completion?(.failure(NFCError.unavailable))
            return
        }
        
        shared.action = action
        shared.completion = completion
        
//        shared.sessionNFCNDEF = NFCNDEFReaderSession(delegate: shared.self, queue: nil, invalidateAfterFirstRead: false)
//        
//        shared.sessionNFCNDEF?.alertMessage = action.alertMessage
//        shared.sessionNFCNDEF?.begin()
        shared.nfcSession = NFCTagReaderSession(pollingOption: [.iso14443], delegate: shared.self, queue: nil)
        shared.nfcSession?.alertMessage = action.alertMessage
        shared.nfcSession?.begin()
        
    }
    
    private func handleError(_ error : Error)
    {
        sessionNFCNDEF?.alertMessage = error.localizedDescription
        sessionNFCNDEF?.invalidate()
    }
    
    func extractCoordinates(from geoString: String) -> (latitude: Double, longitude: Double)? {
        // Ensure the string starts with "geo:"
        guard geoString.hasPrefix("geo:") else { return nil }
        
        // Remove the "geo:" prefix
        let coordinatesString = geoString.replacingOccurrences(of: "geo:", with: "")
        
        // Split the remaining string by the comma
        let coordinates = coordinatesString.split(separator: ",")
        
        // Ensure there are exactly two components (latitude and longitude)
        guard coordinates.count == 2,
              let latitude = Double(coordinates[0]),
              let longitude = Double(coordinates[1]) else { return nil }
        
        return (latitude, longitude)
    }
}

//extension NFCUtility: NFCNDEFReaderSessionDelegate{
//
//    
//    
//    
//    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
//        
//        if let error = error as? NFCReaderError, error.code != .readerSessionInvalidationErrorFirstNDEFTagRead && error.code != .readerSessionInvalidationErrorUserCanceled {
//            completion?(.failure(NFCError.invalidated(message: error.localizedDescription)))
//        }
//        
//        self.sessionNFCNDEF = nil
//        completion = nil
//    }
//    
//    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
////        print("NFC=")
////        for message in messages {
////            for record in message.records {
////                print("Type name format: \(record.typeNameFormat)")
////                print("Payload: \(record.payload)")
////                print("Type: \(record.type)")
////                print("Identifier: \(record.identifier)")
////            }
////        }
//    }
//    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
//        
//    }
//    
//    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
//        
//        guard let tag = tags.first,tags.count ==  1 else {
//            session.alertMessage = "There_are_too_many_tags_present_Remove_all_and_try_again".localized
//            DispatchQueue.global().asyncAfter(deadline: .now() + .microseconds(500)){ session.restartPolling()}
//            return
//        }
//        
//        session.connect(to: tag){ error in
//            if let error = error{
//                self.handleError(error)
//                return
//            }
//        }
//        //
//        tag.queryNDEFStatus{ status,_, error in
//            if let error = error{
//                self.handleError(error)
//                return
//            }
//            
//            switch (status,self.action){
//            case (.notSupported,_ ):
//                session.alertMessage = "The_tag_is_not_supported_please_contact_the_administrator_in_your_organization".localized
//                session.invalidate()
//            case (.readOnly,_):
//                session.alertMessage = "Unable to write to tag"
//                session.invalidate()
//                //            case (.readWrite,.setupLocation(let locationName)):
//                //                self.createLocation(name : locationName,with: tag)
//            case (.readWrite,.readTaskByNFC):
//                self.readLocation(from: tag)
//                return
//            default :
//                return
//                
//                
//            }
//            
//        }
//        
//    }
//    
//    func createLocation(name : String, with tag : NFCNDEFTag){
//        //        guard let payload = NFCNDEFPayload.wellKnownTypeTextPayload(string: name, locale: Locale.current) else {
//        //            handleError(NFCError.invalidated(message: "Could not create payload"))
//        //            return
//        //        }
//        //
//        //        let message = NFCNDEFMessage(records: [payload])
//        //
//        //        tag.writeNDEF(message){ error in
//        //
//        //            if let error = error{
//        //                self.handleError(error)
//        //                return
//        //            }
//        //            self.session?.alertMessage = "Wrote Location data"
//        //            self.session?.invalidate()
//        //            self.completion?(.success(TaskByNFC(name: name)))
//        //
//        //        }
//    }
//    
//    func readLocation(from tag : NFCNDEFTag){
//        tag.readNDEF{ message,error in
//            
//            if let error = error {
//                self.handleError(error)
//                return
//            }
//            
//            guard let message = message else{
//                self.sessionNFCNDEF?.alertMessage = "Tag_could_not_be_read_please_try_again".localized
//                self.sessionNFCNDEF?.invalidate()
//                return
//            }
//            
//            
//            var lat : Double?
//            var long: Double?
//            var name: String?
//            for record in message.records {
//                if record.typeNameFormat == .nfcWellKnown {
//                    // Check if the payload is text for taskId
//                    if record.type == "T".data(using: .utf8) {
//                        
//                        if let taskId = record.wellKnownTypeTextPayload().0 {
//                            //TaskByNFC(name: taskId)
//                            name = taskId
//                            print("Task ID: \(String(describing: record.wellKnownTypeTextPayload().0))")
//                        }
//                    }
//                    // Check if the payload is custom location data
////                    else if record.type == "U".data(using: .utf8) {
////                        
////                        if let (latitude, longitude) = self.extractCoordinates(from: record.wellKnownTypeURIPayload()?.absoluteString ?? "") {
////                            print("Latitude: \(latitude), Longitude: \(longitude)")
////                            lat = latitude
////                            long = longitude
////                            // TaskByNFC(lat: latitude, long: longitude)
////                        } else {
////                            print("Invalid geo string format.")
////                        }
////                        
////                    }
//                }
//            }
//            
//            
//            
//            self.completion?(.success(TaskByNFC(UID: "", name: name, lat: lat, long: long)))
//            self.sessionNFCNDEF?.alertMessage = "" //"Read_Tag".localized
//            self.sessionNFCNDEF?.invalidate()
//            
//            
//        }
//    }
//
//    
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
//}


extension NFCUtility: NFCTagReaderSessionDelegate {
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else { return }
        
        switch tag {
        case .miFare(let mifareTag):
            print("MIFARE tag detected with UID: \(mifareTag.identifier.hexEncodedString())")

            session.connect(to: tag) { [weak self] error in
                if let error = error {
                    print("Error connecting to tag: \(error.localizedDescription)")
                    session.invalidate()
                    return
                }
                // Now that we are connected, try to read NDEF data
                
                mifareTag.readNDEF { message, error in
                    self?.handleNDEFMessage(message, uID: mifareTag.identifier.hexEncodedString(), error: error, session: session)
                }
            }
        
        case .iso7816(let isoTag):
            session.connect(to: tag) { [weak self] error in
                if let error = error {
                    print("Error connecting to tag: \(error.localizedDescription)")
                    session.invalidate()
                    return
                }
                // Now that we are connected, try to read NDEF data
                isoTag.readNDEF { message, error in
                    self?.handleNDEFMessage(message, uID: isoTag.identifier.hexEncodedString(), error: error, session: session)
                }
            }
            
        case .feliCa(let feliCaTag):
            
            session.connect(to: tag) { [weak self] error in
                if let error = error {
                    print("Error connecting to tag: \(error.localizedDescription)")
                    session.invalidate()
                    return
                }
                // Now that we are connected, try to read NDEF data
                feliCaTag.readNDEF { message, error in
                    self?.handleNDEFMessage(message, uID: feliCaTag.description, error: error, session: session)
                }
            }
        case .iso15693(let iso15693Tag):
            
            session.connect(to: tag) { [weak self] error in
                if let error = error {
                    print("Error connecting to tag: \(error.localizedDescription)")
                    session.invalidate()
                    return
                }
                // Now that we are connected, try to read NDEF data
                iso15693Tag.readNDEF { message, error in
                    self?.handleNDEFMessage(message, uID: iso15693Tag.identifier.hexEncodedString(), error: error, session: session)
                }
            }
        @unknown default:
            break
        }
    }
    
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Session Begin!")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // Handle the NDEF message and error
    func handleNDEFMessage(_ message: NFCNDEFMessage?, uID: String, error: Error?, session: NFCTagReaderSession) {
        
        var lat : Double?
        var long: Double?
        var name: String?
        if let error = error {
            self.completion?(.success(TaskByNFC(UID: uID, name: name, lat: lat, long: long)))
            self.nfcSession?.alertMessage = error.localizedDescription
            self.nfcSession?.invalidate()
            return
        }
        
        guard let message = message else{
            self.sessionNFCNDEF?.alertMessage = "Tag_could_not_be_read_please_try_again".localized
            self.sessionNFCNDEF?.invalidate()
            return
        }
        
        
        
        for record in message.records {
            if record.typeNameFormat == .nfcWellKnown {
                // Check if the payload is text for taskId
                if record.type == "T".data(using: .utf8) {
                    
                    if let taskId = record.wellKnownTypeTextPayload().0 {
                        //TaskByNFC(name: taskId)
                        name = taskId
                        print("Task ID: \(String(describing: record.wellKnownTypeTextPayload().0))")
                    }
                }
                // Check if the payload is custom location data
                else if record.type == "U".data(using: .utf8) {
                    
                    if let (latitude, longitude) = self.extractCoordinates(from: record.wellKnownTypeURIPayload()?.absoluteString ?? "") {
                        print("Latitude: \(latitude), Longitude: \(longitude)")
                        lat = latitude
                        long = longitude
                        // TaskByNFC(lat: latitude, long: longitude)
                    } else {
                        print("Invalid geo string format.")
                    }
                    
                }
            }
        }
        
        self.completion?(.success(TaskByNFC(UID: uID, name: name, lat: lat, long: long)))
        self.nfcSession?.alertMessage = "" //"Read_Tag".localized
        self.nfcSession?.invalidate()
        
        
//        if let error = error {
//            print("Error reading NDEF message: \(error.localizedDescription)")
//            session.alertMessage = "Failed to read NDEF message."
//            session.invalidate()
//            return
//        }
//        
//        guard let message = message else {
//            print("No NDEF message found.")
//            session.alertMessage = "No NDEF message found."
//            session.invalidate()
//            return
//        }
//        
//        // Process each NDEF record
//        for record in message.records {
//            print("NDEF Record Type: \(record.type), Payload: \(record.payload)")
//            // Example of accessing text payload
//            if let text = record.wellKnownTypeTextPayload().0 {
//                print("Text Payload: \(text)")
//            }
//        }
//        
//        // Invalidate the session after reading
//        session.invalidate()
    }
}

extension Data {
    func hexEncodedString() -> String {
        return self.map { String(format: "%02hhx", $0) }.joined()
    }
}
