//
//  PushNotification+CoreDataProperties.swift
//  clock2go2020
//
//  Created by Admin on 3/13/20.
//
//

import Foundation
import CoreData

extension PushNotification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PushNotification> {
        return NSFetchRequest<PushNotification>(entityName: "Notification")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isManager: Bool
    @NSManaged public var isUnread: Bool
    @NSManaged public var message: String?
    @NSManaged public var notificationType: String?
    @NSManaged public var notificationId: String?

}
