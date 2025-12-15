//
//  TaskListViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/13/20.
//

import Foundation

enum TaskListType {
    case task
    case client
}

class TaskListViewModel {
    
    /// Closure which is called when some section collapses automatically and
    ///     it is necessary to update UI accordingly.
    var sectionCollapsed: ((Int) -> Void)?
    
    /// task list hierarchy.
     var taskListItems: [TaskListItem]
    
    private var isFilterActivated: Bool = false
    var taskListType: TaskListType = .task
    
    /// fitered task list hierarchy.
    private var filteredTaskListItems: [TaskListItem]
    
    var selectedTask: TaskObj?
    
    var showAddTask: Bool
    var searchButtonHidden: Bool = false
    
    var isRevacha: Bool {
        return CompaniesDataManager.shared.isRevacha()
    }
    
    var isHolocust: Bool {
        return CompaniesDataManager.shared.isHolocaustSurvivors()
    }
    
    init(showAddTask: Bool = true) {
        taskListItems = []
        filteredTaskListItems = []
        self.showAddTask = showAddTask
        
        if isRevacha {
            taskListType = .client
            self.searchButtonHidden = true
        }else if self.isHolocust{
            taskListType = .client
            self.searchButtonHidden = true
        }else {
            self.searchButtonHidden = !CompaniesDataManager.shared.hasTaskSearchFeature()
        }
        
        self.updateTaskList()
    }
    
    func shouldShowAddTaskTextField() -> Bool {
        if self.isRevacha{
            return true
        }else if self.isHolocust{
            return true
        }
        return false
    }
    
    func shouldHideAddTaskButton() -> Bool {
        if (isRevacha || self.isHolocust) || CompaniesDataManager.shared.isBituachLeumi() {
            return true
        }
        if CompaniesDataManager.shared.hasCreateClientTaskFeature() {
            return false
        }
        return showAddTask ? !CompaniesDataManager.shared.hasAddTaskFeature() : true
    }
    
    func shouldAddClientTask() -> Bool {
        return CompaniesDataManager.shared.hasCreateClientTaskFeature()
    }
    
    func getSearchPlaseholder() -> String {
        return shouldHideAddTaskButton() ? "SEARCH_TASK".localized : "SEARCH_ADD_TASK".localized
    }
    
    func shouldEnableAddTaskButton() -> Bool {
        return isFilterActivated
    }
    
    func updateTaskList() {
        if let tasks = CompaniesDataManager.shared.getAvailableTasks() as? [TaskObj] {
            if isHolocust{
                if UserDefaultsManager.holocustLastLoginType == 5{
                    // Online
                    let filteredTask = tasks.filter { $0.trnstypeid == 2 && $0.TherapyType == UserDefaultsManager.holocustLastTheraphyType}
                    setup(tasks: filteredTask)
                }else if UserDefaultsManager.holocustLastLoginType == 4{
                    // onSiteTreatment
                    
                    let filteredTask = tasks.filter { $0.trnstypeid == 1 && $0.TherapyType == UserDefaultsManager.holocustLastTheraphyType}
                    setup(tasks: filteredTask)
                }else{
                    // officeTreatment
                    let filteredTask = tasks.filter { $0.trnstypeid == 3 && $0.TherapyType == UserDefaultsManager.holocustLastTheraphyType}
                    setup(tasks: filteredTask)
                }
            }else{
                print("tasks", tasks)
                setup(tasks: tasks)
            }
        }
    }
    
    func setup(tasks: [TaskObj] = []) {
        isFilterActivated = false
        taskListItems = []
        filteredTaskListItems = []
        
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
        
        switch taskListType {
        case .task:
            taskListItems = emptyTask + taskListWithGroup + taskListWithoutGroup
            break
        case .client:
            taskListItems =  taskListWithGroup + taskListWithoutGroup
            break
        }
    }
    
    func filterList(filterText: String) {
        isFilterActivated = true
        filteredTaskListItems = []
        
        for taskListItem in taskListItems {
            guard let item = taskListItem.copy() as? TaskListItem else { return }
            item.isExpanded = taskListItem.isExpanded
            
            if item.task.taskName.lowercased().contains(filterText.lowercased()) {
                filteredTaskListItems.append(item)
            } else {
                let subtasks = item.descendants.filter({($0.task.taskName.lowercased().contains(filterText.lowercased()) )})
                if subtasks.count > 0 {
                    item.descendants = subtasks
                    item.isExpanded = true
                    filteredTaskListItems.append(item)
                }
            }
            
        }
    }
    
    func unfilterList() {
        // collapseItems()
        isFilterActivated = false
        filteredTaskListItems = []
    }
    
    func getNumberOfSections() -> Int {
        return isFilterActivated ? filteredTaskListItems.count : taskListItems.count
    }
    
    func getNumberOfRows(section: Int) -> Int {
        let taskListArray = isFilterActivated ? filteredTaskListItems : taskListItems
        
        if taskListArray.indices.contains(section) {
            let item = taskListArray[section]
            
            // Check if menu has descendant submenus and if it's expanded.
            if item.descendants.count > 0 && item.isExpanded {
                // Return number of descendant submenus + root menu item.
                return item.flatDescendants.count + 1
            } else {
                // Return only root menu item.
                return 1
            }
        } else {
            return 0
        }
    }
    
    func getNumberOfExpandedRows() -> Int {
        let taskListArray = isFilterActivated ? filteredTaskListItems : taskListItems
        
        var row = taskListArray.count
        
        for item in taskListArray {
            if item.isExpanded {
                row += item.flatDescendants.count
            }
        }
        
        return row
    }
    
    func getModelForItemAt(section: Int, row: Int) -> TaskListItemViewModel? {
        let taskListArray = isFilterActivated ? filteredTaskListItems : taskListItems
        
        if taskListArray.indices.contains(section) {
            if row == 0 {
                let item = taskListArray[section]
                return TaskListItemViewModel(item: item)
            } else {
                if taskListArray[section].flatDescendants.indices.contains(row - 1) {
                    let item = taskListArray[section].flatDescendants[row - 1]
                    return TaskListItemViewModel(item: item)
                }
            }
        }
        
        return nil
    }
    
    func isItemExpandable(section: Int, row: Int) -> Bool {
        let taskListArray = isFilterActivated ? filteredTaskListItems : taskListItems
        
        if taskListArray.indices.contains(section) {
            if row == 0 {
                return taskListArray[section].descendants.count > 0
            }
        }
        
        return false
    }
    
    func toggleItem(section: Int, row: Int) {
        let taskListArray = isFilterActivated ? filteredTaskListItems : taskListItems
        
        if taskListArray.indices.contains(section) {
            if row == 0 {
                let item = taskListArray[section]
                if item.descendants.count > 0 {
                    item.isExpanded = !item.isExpanded
                }
            }
        }
    }
    
    private func collapseItems() {
        for menuIndex in 0..<taskListItems.count {
            let item = taskListItems[menuIndex]
            if item.isExpanded {
                item.isExpanded = false
                sectionCollapsed?(menuIndex)
            }
        }
    }
    
    func selectTask(by index: IndexPath) {
        let taskListArray = isFilterActivated ? filteredTaskListItems : taskListItems
        
        if taskListArray.indices.contains(index.section) {
            if index.row == 0 {
                let item = taskListArray[index.section]
                selectedTask = item.task
            } else {
                if taskListArray[index.section].flatDescendants.indices.contains(index.row - 1) {
                    let item = taskListArray[index.section].flatDescendants[index.row - 1]
                    selectedTask = item.task
                }
            }
        }
        
        if let task = selectedTask, task.taskId.count == 0{
            selectedTask = nil
        }
    }
    
    func selectTask(by name: String) {
        let taskListArray = taskListItems.sorted(by: { Int($0.task.taskId) ?? 0 > Int($1.task.taskId) ?? 0 })
        selectedTask = taskListArray.first { $0.task.taskName == name }?.task
        if selectedTask?.taskId == "" {
            selectedTask = nil
        }
    }
    
    func listTitle() -> String {
        switch taskListType {
        case .task:
            return "SELECT_TASK".localized
        case .client:
            return "SELECT_CLIENT".localized
        }
    }
    
    func addTask(_ task: TaskObj) {
        let taskItem = TaskListItem(task: task)
        taskListItems.insert(taskItem, at: 0)
        selectedTask = task
    }
}
