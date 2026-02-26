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

}
