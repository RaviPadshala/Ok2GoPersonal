//
//  CheckInSecurityService.swift
//  clock2go2020
//
//  Created by YASH COMPUTERS on 30/04/26.
//

import Foundation
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import UIKit
import DeviceCheck
import MachO

public struct RiskFlag: OptionSet {
    public let rawValue: UInt64
    public init(rawValue: UInt64) { self.rawValue = rawValue }
    public static let simulatedLocation      = RiskFlag(rawValue: 1<<0)
    public static let accessoryLocation      = RiskFlag(rawValue: 1<<1)
    public static let lowAccuracy            = RiskFlag(rawValue: 1<<2)
    public static let timeSkew               = RiskFlag(rawValue: 1<<3)
    public static let jailbreakSuspected     = RiskFlag(rawValue: 1<<4)
    public static let hookingSuspected       = RiskFlag(rawValue: 1<<5)
    public static let bssidMismatch          = RiskFlag(rawValue: 1<<6)
    public static let offlineWindowExceeded  = RiskFlag(rawValue: 1<<7)
    public static let attestMissing          = RiskFlag(rawValue: 1<<8)
}

public struct ValidatedLocation {
    public let location: CLLocation
    public let riskFlags: RiskFlag
    public let bssid: String?
}

// Minimal BSSID helper
public enum WiFiBSSIDProvider {
    public static func currentBSSID() -> String? {
        guard let interfaces = CNCopySupportedInterfaces() as? [String],
              let first = interfaces.first,
              let dict = CNCopyCurrentNetworkInfo(first as CFString) as? [String: Any],
              let bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String else {
            return nil
        }
        return bssid
    }
}

// Location validator
public final class LocationValidator: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<ValidatedLocation, Error>?
    private var approvedBSSIDs: Set<String>?

    public override init() {
        super.init()
        manager.delegate = self
    }

    public func currentValidatedLocation(approvedBSSIDs: Set<String>?) async throws -> ValidatedLocation {
        self.approvedBSSIDs = approvedBSSIDs
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestLocation()
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<ValidatedLocation, Error>) in
            self.continuation = continuation
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        var flags: RiskFlag = []

        if #available(iOS 15.0, *), let src = loc.sourceInformation {
            if src.isSimulatedBySoftware { flags.insert(.simulatedLocation) }
            if src.isProducedByAccessory { flags.insert(.accessoryLocation) }
        }
        if loc.horizontalAccuracy > 100 { flags.insert(.lowAccuracy) }

        let bssid = WiFiBSSIDProvider.currentBSSID()
        if let approved = approvedBSSIDs, let current = bssid, !approved.isEmpty, !approved.contains(current) {
            flags.insert(.bssidMismatch)
        }

        continuation?.resume(returning: ValidatedLocation(location: loc, riskFlags: flags, bssid: bssid))
        continuation = nil
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

public enum TimeSource {
    public static func monotonicUptimeSeconds() -> TimeInterval { ProcessInfo.processInfo.systemUptime }
    public static func deviceWallClock() -> Date { Date() }
}

// Secure signing for offline events
//public final class OfflineSigner {
//    private let tag = "com.company.attendance.devicekey"
//    private var privateKey: SecKey?
//
//    public init() { self.privateKey = try? Self.loadOrCreateKey(tag: tag) }
//
//    public func sign(eventData: Data) throws -> Data {
//        let key = try privateKeyOrThrow()
//        var error: Unmanaged<CFError>?
//        guard let sig = SecKeyCreateSignature(key, .ecdsaSignatureMessageX962SHA256, eventData as CFData, &error) as Data? else {
//            throw error!.takeRetainedValue() as Error
//        }
//        return sig
//    }
//
//    public func publicKeyDER() throws -> Data {
//        let key = try privateKeyOrThrow()
//        guard let pub = SecKeyCopyPublicKey(key) else { throw NSError(domain: "Signer", code: -1) }
//        var error: Unmanaged<CFError>?
//        guard let data = SecKeyCopyExternalRepresentation(pub, &error) as Data? else { throw error!.takeRetainedValue() as Error }
//        return data
//    }
//
//    private func privateKeyOrThrow() throws -> SecKey {
//        if let k = privateKey { return k }
//        privateKey = try Self.loadOrCreateKey(tag: tag)
//        return privateKey!
//    }
//
//    private static func loadOrCreateKey(tag: String) throws -> SecKey {
//        let tagData = tag.data(using: .utf8)!
//        var query: [String: Any] = [
//            kSecClass as String: kSecClassKey,
//            kSecAttrApplicationTag as String: tagData,
//            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
//            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
//            kSecReturnRef as String: true
//        ]
//        var item: CFTypeRef?
//        let status = SecItemCopyMatching(query as CFDictionary, &item)
//        if status == errSecSuccess, let found = item {
//            return (found as! SecKey)
//        }
//
//        let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, [.privateKeyUsage], nil)!
//        var error: Unmanaged<CFError>?
//
//        // Try Secure Enclave
//        let attrsSE: [String: Any] = [
//            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
//            kSecAttrKeySizeInBits as String: 256,
//            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
//            kSecPrivateKeyAttrs as String: [
//                kSecAttrIsPermanent as String: true,
//                kSecAttrApplicationTag as String: tagData,
//                kSecAttrAccessControl as String: access
//            ]
//        ]
//        if let key = SecKeyCreateRandomKey(attrsSE as CFDictionary, &error) { return key }
//
//        // Fallback software key
//        let attrsSW: [String: Any] = [
//            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
//            kSecAttrKeySizeInBits as String: 256,
//            kSecPrivateKeyAttrs as String: [
//                kSecAttrIsPermanent as String: true,
//                kSecAttrApplicationTag as String: tagData,
//                kSecAttrAccessControl as String: access
//            ]
//        ]
//        guard let sw = SecKeyCreateRandomKey(attrsSW as CFDictionary, &error) else { throw error!.takeRetainedValue() as Error }
//        return sw
//    }
//}

//public struct OfflineEvent: Codable {
//    public let userId: Int
//    public let deviceId: String
//    public let timestamp: Date
//    public let uptimeAtCreation: TimeInterval
//    public let lat: Double
//    public let lon: Double
//    public let accuracy: Double
//    public let bssid: String?
//    public let riskFlagsRaw: UInt64
//    public let counter: UInt64
//
//    public func canonicalJSONData() throws -> Data {
//        let iso = ISO8601DateFormatter()
//        let dict: [String: Any] = [
//            "accuracy": accuracy,
//            "bssid": bssid as Any,
//            "counter": counter,
//            "deviceId": deviceId,
//            "lat": lat,
//            "lon": lon,
//            "riskFlagsRaw": riskFlagsRaw,
//            "timestamp": iso.string(from: timestamp),
//            "uptimeAtCreation": uptimeAtCreation,
//            "userId": userId
//        ]
//        let keys = ["accuracy","bssid","counter","deviceId","lat","lon","riskFlagsRaw","timestamp","uptimeAtCreation","userId"]
//        var components: [String] = []
//        for k in keys {
//            let v = dict[k]!
//            let jsonValue: String
//            if let s = v as? String { jsonValue = "\"\(s)\"" }
//            else if let n = v as? NSNumber { jsonValue = n.stringValue }
//            else if let d = v as? Double { jsonValue = String(d) }
//            else if let i = v as? Int { jsonValue = String(i) }
//            else if let b = v as? Bool { jsonValue = b ? "true" : "false" }
//            else if v is NSNull { jsonValue = "null" }
//            else { jsonValue = "\"\(String(describing: v))\"" }
//            components.append("\"\(k)\":\(jsonValue)")
//        }
//        let json = "{" + components.joined(separator: ",") + "}"
//        return Data(json.utf8)
//    }
//
//    public func signedEnvelope(using signer: OfflineSigner) throws -> Data {
//        let payload = try canonicalJSONData()
//        let signature = try signer.sign(eventData: payload)
//        let pub = try signer.publicKeyDER()
//        let envelope = [
//            "payload": payload.base64EncodedString(),
//            "signature": signature.base64EncodedString(),
//            "publicKey": pub.base64EncodedString()
//        ]
//        return try JSONSerialization.data(withJSONObject: envelope, options: [])
//    }
//}

public final class DeviceIntegrity {
    public init() {}
    public func jailbreakIndicators() -> [String] {
        var ind: [String] = []
        let suspicious = ["/Applications/Cydia.app","/Library/MobileSubstrate/MobileSubstrate.dylib","/bin/bash","/usr/sbin/sshd","/etc/apt"]
        for p in suspicious { if FileManager.default.fileExists(atPath: p) { ind.append("exists:\(p)") } }
        let testPath = "/private/jbtest.txt"
        do { try "x".write(toFile: testPath, atomically: true, encoding: .utf8); ind.append("writable:/private"); try? FileManager.default.removeItem(atPath: testPath) } catch {}
        if let url = URL(string: "cydia://package/com.example.package"), UIApplication.shared.canOpenURL(url) { ind.append("cydiaURL") }
        #if canImport(MachO)
        let count = _dyld_image_count()
        if count > 0 {
            for i in 0..<(Int(count)) {
                if let cstr = _dyld_get_image_name(UInt32(i)) {
                    let name = String(cString: cstr)
                    let lower = name.lowercased()
                    if lower.contains("substrate") || lower.contains("frida") {
                        ind.append("image:\(lower)")
                    }
                }
            }
        }
        #endif
        return ind
    }
    public func riskFlags() -> RiskFlag {
        let ind = jailbreakIndicators()
        var flags: RiskFlag = []
        if ind.contains(where: { $0.contains("substrate") || $0.contains("cydia") || $0.contains("writable:/private") }) { flags.insert(.jailbreakSuspected) }
        if ind.contains(where: { $0.contains("frida") }) { flags.insert(.hookingSuspected) }
        return flags
    }
}

public enum AttestationStubs {
    public static func deviceCheckToken(completion: @escaping (Result<Data, Error>) -> Void) {
        guard DCDevice.current.isSupported else { completion(.failure(NSError(domain: "DeviceCheck", code: -1))); return }
        DCDevice.current.generateToken { data, error in
            if let data = data { completion(.success(data)) }
            else { completion(.failure(error ?? NSError(domain: "DeviceCheck", code: -2))) }
        }
    }
}

public enum RiskScorer {
    public static func score(for loc: ValidatedLocation, timeDeltaSeconds: TimeInterval, integrityFlags: RiskFlag, offlineWindowHours: Double) -> Int {
        var score = 0
        if loc.riskFlags.contains(.simulatedLocation) { score += 50 }
        if loc.riskFlags.contains(.accessoryLocation) { score += 20 }
        if loc.riskFlags.contains(.lowAccuracy) { score += 10 }
        if loc.riskFlags.contains(.bssidMismatch) { score += 15 }
        if integrityFlags.contains(.jailbreakSuspected) { score += 40 }
        if integrityFlags.contains(.hookingSuspected) { score += 40 }
        if abs(timeDeltaSeconds) > 300 { score += 30 }
        return score
    }
}

public final class CheckInSecurityService {
    private let validator = LocationValidator()
//    private let signer = OfflineSigner()
    public init() {}

    public struct Result {
        public let validatedLocation: ValidatedLocation
        public let integrityFlags: RiskFlag
//        public let signedEnvelope: Data
        public let riskScore: Int
    }

    public func performCheckIn(userId: Int, deviceId: String, counter: UInt64, approvedBSSIDs: Set<String>?, serverNow: Date, offlineWindowHours: Double) async throws -> Result {
        let validated = try await validator.currentValidatedLocation(approvedBSSIDs: approvedBSSIDs)
        let timeDelta = serverNow.timeIntervalSince(Date())
        let integrity = DeviceIntegrity().riskFlags()
//        let event = OfflineEvent(
//            userId: userId,
//            deviceId: deviceId,
//            timestamp: Date(),
//            uptimeAtCreation: TimeSource.monotonicUptimeSeconds(),
//            lat: validated.location.coordinate.latitude,
//            lon: validated.location.coordinate.longitude,
//            accuracy: validated.location.horizontalAccuracy,
//            bssid: validated.bssid,
//            riskFlagsRaw: validated.riskFlags.union(integrity).rawValue,
//            counter: counter
//        )
//        let envelope = try event.signedEnvelope(using: signer)
        let risk = RiskScorer.score(for: validated, timeDeltaSeconds: timeDelta, integrityFlags: integrity, offlineWindowHours: offlineWindowHours)
        return Result(validatedLocation: validated, integrityFlags: integrity, riskScore: risk)
    }
}

