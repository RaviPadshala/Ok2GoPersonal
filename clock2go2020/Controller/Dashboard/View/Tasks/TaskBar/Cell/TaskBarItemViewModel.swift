//
//  TaskBarItemViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/14/20.
//

import UIKit

class TaskBarItemViewModel {

    let item: TaskBarItem

    init(item: TaskBarItem) {
        self.item = item
    }

    func getTaskName() -> String {
        return item.task?.taskName ?? ""
    }

    func getTaskDateString() -> String {
        return String(item.task?.time.prefix(5) ?? "")
    }

    func getBackgroundColor() -> UIColor? {
        if item.isActive {
            if item.task?.actionType == nil {
                return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
            }

            if item.task?.actionType == "1" || item.task?.actionType == ReportActionType.serviceEntry.rawValue {
//                if item.task?.event == nil {
//                    return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
//                } else {
//                    return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//                }
                return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
            } else if item.task?.actionType == "2" || item.task?.actionType == ReportActionType.serviceExit.rawValue {
                return #colorLiteral(red: 0.9756608605, green: 0.3157561719, blue: 0.3174736798, alpha: 1)
            } else if item.task?.actionType == "98" {
                return #colorLiteral(red: 0.9773489833, green: 0.4326385856, blue: 0.8032094836, alpha: 1)
            } else if item.task?.actionType == "99" {
                return #colorLiteral(red: 0.9866847396, green: 0.7379429936, blue: 0.9088150859, alpha: 1)
            }

            if let color = getSpecialClientBackgroundColor() {
                return color
            }

            if let color = getAdditionButtonBackgroundColor() {
                return color
            }
        }

        return #colorLiteral(red: 0.7666191459, green: 0.8633292317, blue: 0.9326800704, alpha: 1)
    }

    func getSpecialClientBackgroundColor() -> UIColor? {
        if (CompaniesDataManager.shared.getSpecialClientType() == 1 ||
            CompaniesDataManager.shared.getSpecialClientType() == 2),
            let additionalButtons = CompaniesDataManager.shared.getAddonButtons(),
            let additionalButton1ActionType = additionalButtons.button_1?.action_type?.description,
            let additionalButton2ActionType = additionalButtons.button_2?.action_type?.description {

            if item.task?.actionType == additionalButton1ActionType {
                return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
            } else if item.task?.actionType == additionalButton2ActionType {
                return #colorLiteral(red: 0.9756608605, green: 0.3157561719, blue: 0.3174736798, alpha: 1)
            }
        }

        return nil
    }

    func getAdditionButtonBackgroundColor() -> UIColor? {
        if  let additionalButtons = CompaniesDataManager.shared.getAddonButtons() {

            let additionalButton1ActionType = additionalButtons.button_1?.action_type?.description
            let additionalButton2ActionType = additionalButtons.button_2?.action_type?.description
            let additionalButton3ActionType = additionalButtons.button_3?.action_type?.description
            let additionalButton4ActionType = additionalButtons.button_4?.action_type?.description
            let additionalButton5ActionType = additionalButtons.button_5?.action_type?.description
            let additionalButton6ActionType = additionalButtons.button_6?.action_type?.description

            if item.task?.actionType == additionalButton1ActionType || item.task?.actionType == additionalButton3ActionType || item.task?.actionType == additionalButton5ActionType {
                return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
            } else if item.task?.actionType == additionalButton2ActionType || item.task?.actionType == additionalButton4ActionType || item.task?.actionType == additionalButton6ActionType {
                return #colorLiteral(red: 0.9756608605, green: 0.3157561719, blue: 0.3174736798, alpha: 1)
            }
        }

        return nil
    }

}
