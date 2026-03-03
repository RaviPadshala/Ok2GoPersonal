//
//  OfflineRequestsManager.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 19.08.2020.
//

import UIKit
import CoreData

class OfflineRequestsManager: NSObject {

    // MARK: - Singleton

    /// Unique instance of cache manager.
    @objc static let sharedInstance = OfflineRequestsManager()

    /// Outside instances are prohibited.
    private override init() {
        super.init()
    }

    private func getManagedContext() -> NSManagedObjectContext {
        return OfflineModeCoreDataStorage.mainQueueContext()
    }

    lazy var context = getManagedContext()

    func save() {
        if context.hasChanges {
            do {
                try context.save()
                debugPrint(context.userInfo)
                print("saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func save(reportPicture: ReportPictureObj) {
        let request = Request(context: context)
        request.set(with: reportPicture)
        self.save()
    }

    func save(type: String?, taskId: String?, taskName: String?, remark: String?, locationName: Int?) {
        let request = Request(context: context)
        request.set(type: type, taskId: taskId, taskName: taskName, remark: remark, locationName: locationName)
        self.save()
    }

    func save(type: Int?, distance: Double?, accuracy: Int?) {
        let request = Request(context: context)
        request.set(type: type, distance: distance, accuracy: accuracy)
        self.save()
    }

    func save(type: String?) {
        let request = Request(context: context)
        request.set(type: type)
        self.save()
    }

    func save(type: String?, appVersion: String?, hasLocationPermission: Bool, locationEnabled: Bool, batteryLevel: Int, isFlightMode: Bool) {
        let request = Request(context: context)
        request.set(appVersion: appVersion, hasLocationPermission: hasLocationPermission, locationEnabled: locationEnabled, batteryLevel: batteryLevel, isFlightMode: isFlightMode)
        save()
    }

    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]

            return fetchedObjects ?? [T]()

        } catch {
            print(error)
            return [T]()
        }

    }

    func delete(_ object: NSManagedObject) {
        context.delete(object)
        save()
    }

    func getOfflineReport() -> [ReportObj]{
        var arr: [ReportObj] = []
        let requests = self.fetch(Request.self)
        if !requests.isEmpty {
            for item in requests {
                let endpoint = OfflineRequestEndpoint(offlineRequest: item)
                if let dict = endpoint.convertToDictionary() {
                    // Attempt to extract a human-readable address if available
                    let locationAddress = dict["location"] as? String
                    let report = makeReportObj(from: dict, locationAddress: locationAddress)
                    arr.append(report)
                }
            }
        }
        return arr
    }
    
    func makeReportObj(from input: [String: Any], locationAddress: String?) -> ReportObj {
        
        // 1️⃣ Extract raw values
        var timestamp = input["timestamp"] as? TimeInterval ?? 0
        

        if let numberValue = input["timestamp"] as? NSNumber {
            timestamp = numberValue.doubleValue
        }
        
        let timezoneString = input["timezone"] as? String ?? "UTC"
        let lat = input["lat"] as? Double
        let lon = input["lon"] as? Double
        let type = input["type"] as? String
        let taskId = input["taskId"] as? String
        let fullTaskName = input["taskName"] as? String ?? ""
        
        
        // 5️⃣ Create ReportObj
        return ReportObj(
            time: self.convertTimestampToTime(timestamp, timezone: timezoneString),
            actionType: type,
            location: locationAddress,
            lon: String(lon!),
            lat: String(lat!),
            taskName: fullTaskName,
            taskId: taskId,
            remark: nil,
            healthDisclaimerAccepted: nil,
            event: nil
        )
    }
    
    func convertTimestampToTime(_ timestamp: TimeInterval,
                                timezone: String) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: timezone)
        return formatter.string(from: date)
    }
}
