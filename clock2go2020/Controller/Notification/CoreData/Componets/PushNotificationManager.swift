//
//  PushNotificationManager.swift
//  clock2go2020
//
//  Created by Admin on 3/12/20.
//

import UIKit
import CoreData
import OneSignal

class PushNotificationManager: NSObject {

    // MARK: - Singleton

    /// Unique instance of cache manager.
    @objc static let sharedInstance = PushNotificationManager()

    /// Outside instances are prohibited.
    private override init() {
        super.init()
    }

    private func getManagedContext() -> NSManagedObjectContext {
        return CoreDataStorage.mainQueueContext()
    }

    lazy var context = getManagedContext()

    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func save(payload: OSNotificationPayload) {
        let notification = PushNotification(context: context)
        notification.setInfoWith(payload: payload)
        self.save()
    }

    func save(request: UNNotificationRequest) {
        let notification = PushNotification(context: context)
        notification.setInfoWith(request: request)
        self.save()
    }

    func fetch<T: NSManagedObject>(_ objectType: T.Type, notificationId: String? = nil, unread: Bool = false) -> [T] {
        let entityName = String(describing: objectType)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        if unread {
            fetchRequest.predicate = NSPredicate(format: "isUnread = %@", NSNumber(value: unread))
        }

        if let id = notificationId {
            fetchRequest.predicate = NSPredicate(format: "notificationId = %@", id)
        }

        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]

            return fetchedObjects ?? [T]()

        } catch {
            print(error)
            return [T]()
        }

    }

    func setRead(notificationId: String) {
        if let notification = fetch(PushNotification.self, notificationId: notificationId).first {
            notification.isUnread = false
            save()
        }
    }

    func delete(_ object: NSManagedObject) {
        context.delete(object)
        save()
    }

}
