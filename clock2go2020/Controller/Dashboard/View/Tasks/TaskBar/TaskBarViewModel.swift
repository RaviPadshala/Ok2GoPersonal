//
//  TaskbarViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/14/20.
//

import UIKit

class TaskBarViewModel {

    private var taskBarItems: [TaskBarItem] = []

    var selectedItem: TaskBarItem?

    func refreshData() {
        let tasks = CompaniesDataManager.shared.getLastReportsForTaskBar()
        setTaskBarItems(tasks)
    }

    func setTaskBarItems(_ items: [ReportObj]) {
        taskBarItems = []

        for task in items {
            taskBarItems.append(TaskBarItem(task: task))
        }
        print("taskBarItems", taskBarItems)
    }

    func addTaskBarItem(_ item: TaskBarItem) {
        setAllTaskBarItemUnselected()
        setAllTaskBarItemActive()

        taskBarItems.append(item)
    }

    func getNumberOfItems() -> Int {
        return taskBarItems.count
    }

    func getModelForItemAt(index: Int) -> TaskBarItemViewModel? {
        if taskBarItems.indices.contains(index) {
            let item = taskBarItems[index]
            return TaskBarItemViewModel(item: item)
        }

        return nil
    }

    func setTaskBarItemSelected(index: Int) {
        setAllTaskBarItemActive()
        setAllTaskBarItemUnselected()

        taskBarItems[index].isSelected = true

        selectedItem = taskBarItems[index]
    }

    func setAllTaskBarItemActive() {
        for taskBarItem in taskBarItems {
            taskBarItem.isActive = true
        }
    }

    func setAllTaskBarItemUnselected() {
        for taskBarItem in taskBarItems {
            taskBarItem.isSelected = false
        }
        selectedItem = nil
    }

    func hasItems() -> Bool {
        return taskBarItems.count > 0
    }

    func hasSelectedItem() -> Bool {
        return selectedItem != nil
    }

    func getSelectedItemTitle() -> String {
        if let doctorsTitle = getSpecialClientSelectedItemTitle() {
            return doctorsTitle
        }

        if let item = selectedItem {
            var title = item.task?.taskName ?? ""

            if let additionalActionTitle = getAdditionalButtonsItemTitle() {
                title = additionalActionTitle
            }

            guard let location = item.task?.location else { return title }

            if title != "" {
                title = location + " - " + title
            } else {
                title = location
            }
            
            if let eventName = item.task?.event {
                title = eventName + " - " + title
            }

            return title
        } else {
            return ""
        }
    }

    func getHealthDisclaimerImage() -> UIImage? {
        if selectedItem?.task?.healthDisclaimerAccepted == 1 {
            return UIImage(named: "healthAccepted")
        }

        if selectedItem?.task?.healthDisclaimerAccepted == 0 {
            return UIImage(named: "healthRejected")
        }

        return nil
    }

    func shouldShowMapView() -> Bool {
        if CompaniesDataManager.shared.getSpecialClientType() == 1 ||
            CompaniesDataManager.shared.getSpecialClientType() == 2 {
            return false
        }

        return true
    }

    func getSpecialClientSelectedItemTitle() -> String? {
        if CompaniesDataManager.shared.getSpecialClientType() == 1 ||
            CompaniesDataManager.shared.getSpecialClientType() == 2 {
            if selectedItem?.task?.actionType == "1" {
                return "Login"
            } else if selectedItem?.task?.actionType == "2" {
                return "Logout"
            }

            guard let additionalButtons = CompaniesDataManager.shared.getAddonButtons(),
                let additionalButton1ActionType = additionalButtons.button_1?.action_type?.description,
                let additionalButton2ActionType = additionalButtons.button_2?.action_type?.description else { return "" }

            if selectedItem?.task?.actionType == additionalButton1ActionType {
                return additionalButtons.button_1?.text
            } else if selectedItem?.task?.actionType == additionalButton2ActionType {
                return additionalButtons.button_2?.text
            }
        }

        return nil
    }

    func getAdditionalButtonsItemTitle() -> String? {
        guard let additionalButtons = CompaniesDataManager.shared.getAddonButtons() else { return nil }

        let additionalButton1ActionType = additionalButtons.button_1?.action_type?.description
        let additionalButton2ActionType = additionalButtons.button_2?.action_type?.description
        let additionalButton3ActionType = additionalButtons.button_2?.action_type?.description
        let additionalButton4ActionType = additionalButtons.button_3?.action_type?.description

        if selectedItem?.task?.actionType == additionalButton1ActionType {
            return additionalButtons.button_1?.text
        } else if selectedItem?.task?.actionType == additionalButton2ActionType {
            return additionalButtons.button_2?.text
        } else if selectedItem?.task?.actionType == additionalButton3ActionType {
            return additionalButtons.button_3?.text
        } else if selectedItem?.task?.actionType == additionalButton4ActionType {
            return additionalButtons.button_4?.text
        }

        return nil
    }

}
