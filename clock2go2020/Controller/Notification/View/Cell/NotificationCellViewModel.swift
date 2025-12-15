//
//  NotificationCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/10/20.
//

import UIKit

class NotificationCellViewModel: NSObject {

    private var notification: PushNotification
    private var isSelected: Bool

    init(notification: PushNotification, isSelected: Bool = false) {
        self.notification = notification
        self.isSelected = isSelected
    }

    func getDateLabel() -> String {
        return notification.date?.toString(format: "dd/MM/yy") ?? ""
    }

    func getTimeLabel() -> String {
        return notification.date?.toString(format: "HH:mm") ?? ""
    }

    func getMessageLabel() -> String {
        return notification.message ?? ""
    }

    func getBorderColor() -> UIColor? {
        return isSelected ? #colorLiteral(red: 0, green: 0.4392156863, blue: 0.7529411765, alpha: 1) : (notification.isUnread ? #colorLiteral(red: 0.9990108609, green: 0.4308255315, blue: 0.8036343455, alpha: 1) : #colorLiteral(red: 0.9933295846, green: 0.9966734052, blue: 0.9965329766, alpha: 1))
    }

    func getSelectButtonImage() -> UIImage? {
        return isSelected ? UIImage(named: "checked_terms") : UIImage(named: "unchecked_terms")
    }

}
