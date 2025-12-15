//
//  AdditionalTasksManager.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 31.08.2022.
//

import UIKit
import CoreData

class AdditionalTasksManager {
    
    static func saveTask(_ task: TaskObj) {
        
        guard let empId = CompaniesDataManager.shared.getEmployeeId() else { return }
        guard managedObjectTasks().filter({ $0.taskId == task.taskId && $0.empId == empId }).count == 0 else { return }
        
        let context = managedObjectContext()
        let managedModel = (NSEntityDescription.insertNewObject(forEntityName: String(describing: AdditionalTask.self), into: context)) as! AdditionalTask
        managedModel.taskId = task.taskId
        let cleaned = task.taskName.replacingOccurrences(of: "[0-9\\-]", with: "", options: .regularExpression)
        managedModel.taskName = task.taskName//cleaned + " - " + task.taskId
        managedModel.projectId = Int16(task.projectId ?? -1000)
        managedModel.projectName = task.projectName
        managedModel.empId = Int64(CompaniesDataManager.shared.getEmployeeId() ?? -1000)
        
        saveContext(context)
    }
    
    static func savedTasks() -> [TaskObj] {
        let context = managedObjectContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: AdditionalTask.self))
        do {
            let result = try context.fetch(request)
            var taskList: [TaskObj] = []
            for managedObject in result {
                if let task = managedObject as? AdditionalTask, let empId = CompaniesDataManager.shared.getEmployeeId() {
                    if task.empId == empId {
                        let projectId: Int? = task.projectId == -1000 ? nil : Int(task.projectId)
                        let taskObj = TaskObj(taskId: task.taskId ?? "", taskName: task.taskName ?? "", projectId: projectId, projectName: task.projectName)
                        taskList.append(taskObj)
                    }
                }
            }
            return taskList
        } catch {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
    
    private static func managedObjectTasks() -> [AdditionalTask] {
        let context = managedObjectContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: AdditionalTask.self))
        do {
            let result = try context.fetch(request)
            return result as? [AdditionalTask] ?? []
        } catch {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
    
    static func removeSavedTasks() {
        let context = managedObjectContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: AdditionalTask.self))
        do {
            let result = try context.fetch(request)
            for managedModel in result {
                if let task = managedModel as? AdditionalTask {
                    context.delete(task)
                }
            }
            saveContext(context)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

private extension AdditionalTasksManager {
    
    private static func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

private extension AdditionalTasksManager {
    

    static func managedObjectContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "AdditionalTaskModel")
        container.loadPersistentStores { storeDescription, error in }
        return container.viewContext
    }
    
}
