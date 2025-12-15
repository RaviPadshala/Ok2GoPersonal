//
//  SortingListViewModel.swift
//  clock2go2020
//
//  Created by Admin on 3/22/20.
//

import UIKit

class SortingListViewModel {

    let cellHeight: CGFloat = 30
    var type: SortingListType
    var selectedHolocustTransType = Int()
    var selectedHolocustTherapyType = Int()
    var taskListItems = [TaskListItem]()
    

    init(type: SortingListType, trasType: Int = 0, therapyType: Int = 0) {
        
        self.selectedHolocustTransType = trasType
        self.selectedHolocustTherapyType = therapyType
        print("selectedHolocustTransType", selectedHolocustTransType)
        print("selectedHolocustTherapyType", selectedHolocustTherapyType)
        self.type = type
        if type == .holocustEvent{
            self.updateTaskList()
        }
    }

    func getNumberOfRows() -> Int {
        if type == .holocustEvent{
            return self.taskListItems.count
        }
        return type.numberOfRows
    }

    func getCellTitle(index: Int) -> String {
        if type == .holocustEvent{
            return self.taskListItems[index].task.taskName
        }
        return type.getCellTitleByIndex(index: index)
    }

    func getCellHeight(index: Int) -> CGFloat {
        return type.getCellHeightByIndex(index: index)
    }

    func getTableViewHeight() -> CGFloat {
        var numberOfRows = getNumberOfRows()
        if type == .filter, !CompaniesDataManager.shared.hadStandardWorkTime() {
            numberOfRows = getNumberOfRows() - 1
        }
        let tableHeight = cellHeight * CGFloat(numberOfRows)
        if tableHeight > 210 {
            return 210
        }
        return tableHeight
    }

    func getTitle() -> String {
        return type.title
    }

    func getImage() -> UIImage? {
        return type.image
    }

    func shouldShowHeaderView() -> Bool {
        return type.shouldShowHeader
    }

    func getOnlineOptionEnable() -> Bool {
        if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
            let arr = CompaniesDataManager.shared.getTherapyeventTypes()
            let filteredUsers = arr.filter({ $0?.TransType == "2" })
            if filteredUsers.count > 0 {
                return true
            }
        }
        return false
    }
    
    func getOnSiteOptionEnable() -> Bool {
        if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
            let arr = CompaniesDataManager.shared.getTherapyeventTypes()
            let filteredUsers = arr.filter({ $0?.TransType == "1" })
            if filteredUsers.count > 0 {
                return true
            }
        }
        return false
    }
    
    func getOfficeOptionEnable() -> Bool {
        if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
            let arr = CompaniesDataManager.shared.getTherapyeventTypes()
            let filteredUsers = arr.filter({ $0?.TransType == "3" })
            if filteredUsers.count > 0 {
                return true
            }
        }
        return false
    }
    
    func updateTaskList() {
        if let tasks = CompaniesDataManager.shared.getAvailableTasks() as? [TaskObj] {
            
            if selectedHolocustTransType == 2{
                // Online
                let filteredTask = tasks.filter { $0.trnstypeid == 2 && $0.TherapyType == self.selectedHolocustTherapyType}
                setup(tasks: filteredTask)
            }else if selectedHolocustTransType == 1{
                // onSiteTreatment
                let filteredTask = tasks.filter { $0.trnstypeid == 1 && $0.TherapyType == self.selectedHolocustTherapyType}
                setup(tasks: filteredTask)
            }else{
                // officeTreatment
                let filteredTask = tasks.filter { $0.trnstypeid == 3 && $0.TherapyType == self.selectedHolocustTherapyType}
                setup(tasks: filteredTask)
            }
            
        }
    }
    
    func setup(tasks: [TaskObj] = []) {
        //        isFilterActivated = false
        taskListItems = []
        //        filteredTaskListItems = []
        
        var emptyTask = [TaskListItem(task: TaskObj(taskId: "", taskName: "<No Task>".localized, projectId: nil, projectName: nil, remark: nil, hoursLimit: nil, hoursCompleted: nil, distanceSettings: nil), isRoot: true)]
        if CompaniesDataManager.shared.shouldReportTask() {
            emptyTask = []
        }
        
        var taskListWithGroup: [TaskListItem] = []
        var taskListWithoutGroup: [TaskListItem] = []
        
        let grouped = Dictionary(grouping: tasks, by: { $0.projectName })
        
        for parent in grouped {
            if parent.key != nil {
                let parentTask = TaskObj(taskId: String(parent.value[0].projectId ?? 0), taskName: parent.value[0].projectName ?? "", projectId: nil, projectName: nil)
                let parentItem = TaskListItem(task: parentTask, isRoot: true)
                parentItem.descendants = []
                
                for task in parent.value {
                    let item = TaskListItem(task: task, isRoot: false)
                    parentItem.descendants.append(item)
                }
                
                taskListWithGroup.append(parentItem)
            } else {
                for task in parent.value {
                    let item = TaskListItem(task: task, isRoot: true)
                    taskListWithoutGroup.append(item)
                }
            }
        }
        
        taskListWithoutGroup = taskListWithoutGroup.sorted(by: { $0.task.taskId > $1.task.taskId })
        taskListItems =  taskListWithGroup + taskListWithoutGroup
    }
}
