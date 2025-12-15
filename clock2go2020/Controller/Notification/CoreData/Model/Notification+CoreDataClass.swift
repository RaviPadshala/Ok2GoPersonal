//
//  PushNotification+CoreDataClass.swift
//  clock2go2020
//
//  Created by Admin on 3/13/20.
//
//

import Foundation
import CoreData
import OneSignal

public class PushNotification: NSManagedObject {

    func setInfoWith(payload: OSNotificationPayload) {
        self.date = Date()
        self.isUnread = true
        self.message = payload.body
        self.notificationId = payload.notificationID

        if let additionalData = payload.additionalData, let notificationType = additionalData["notification_type"] as? String, let isManager = additionalData["manager"] as? Int {
            self.notificationType = notificationType
            self.isManager = Bool(truncating: (isManager as NSNumber))
        } else {
            self.isManager = false
        }

    }

    func setInfoWith(request: UNNotificationRequest) {
        self.date = Date()
        self.isUnread = true
        self.message = request.content.body

        let dict = request.content.userInfo
        if let custom = dict["custom"] as? [AnyHashable: Any],
            let additionalInfo = custom["a"] as? [AnyHashable: Any] {

            let manager = (additionalInfo["manager"] as? Int) ?? 0
            let notificationType = additionalInfo["notification_type"] as? String
            let id = custom["i"] as? String

            self.notificationId = id
            self.notificationType = notificationType
            self.isManager = Bool(truncating: (manager as NSNumber))
        }
    }

}
