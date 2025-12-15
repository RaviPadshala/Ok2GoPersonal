//
//  NotificationViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/10/20.
//

import UIKit

class NotificationViewModel {

    private var notifications: [PushNotification] = []
    private var selectedNotifications: [Int] = []

    private var isSelectedAll: Bool

    init() {
        self.isSelectedAll = false

        self.loadNotifications()
    }

    func loadNotifications() {
        notifications = PushNotificationManager.sharedInstance.fetch(PushNotification.self).reversed()
    }

    func getNumberOfNotifications() -> Int {
        return notifications.count
    }

    func shouldDisableDeleteButton() -> Bool {
        return selectedNotifications.count == 0
    }

    func shouldDisableSelectButton() -> Bool {
        return notifications.count == 0
    }

    func getModelFor(index: Int) -> NotificationCellViewModel {
        let isSelected = selectedNotifications.contains(index)
        return NotificationCellViewModel(notification: notifications[index], isSelected: isSelected)
    }

    func changeSelections(value: Int) {
        if let index = selectedNotifications.firstIndex(of: value) {
            selectedNotifications.remove(at: index)
        } else {
            selectedNotifications.append(value)
        }

        updateSelectedAllValue()
    }

    func changeAllSelection() {
        selectedNotifications = !isSelectedAll ? Array(0...notifications.count-1) as [Int] : []

        updateSelectedAllValue()
    }

    func updateSelectedAllValue() {
        if selectedNotifications.count == notifications.count, selectedNotifications.count != 0 {
            isSelectedAll = true
        } else {
            isSelectedAll = false
        }
    }

    func getSelectionImage() -> UIImage? {
        return isSelectedAll ? UIImage(named: "checked_terms") : UIImage(named: "unchecked_terms")
    }

    func getNotificationTitle() -> String {
        let count = PushNotificationManager.sharedInstance.fetch(PushNotification.self, unread: true).count
        return "YOU_HAVE_NUMBER_NEW_ALERTDS".localized.replacingOccurrences(of: "0", with: "\(count)")
    }

    func removeSelectedNotification() {
        for index in selectedNotifications {
            let notification = notifications[index]
            PushNotificationManager.sharedInstance.delete(notification)
        }
        isSelectedAll = false
        selectedNotifications = []
        PushNotificationManager.sharedInstance.save()
    }

    func didSelectNotificationAtIndex(_ index: Int) {
        let notification = notifications[index]

        updateDataBase(notificationId: notification.notificationId)

        let vc = ViewSource.dashboardScreen()
        vc.viewModel.setNotification(notification: notification)

        NavigationController.shared?.setRoot(vc, animated: false)
    }

    func updateDataBase(notificationId: String?) {
        let notifications = PushNotificationManager.sharedInstance.fetch(PushNotification.self, notificationId: notificationId, unread: true)

        for notification in notifications {
            notification.isUnread = false
        }
        PushNotificationManager.sharedInstance.save()
    }

}
