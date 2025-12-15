//
//  BackgroundTasks.swift
//  clock2go2020
//
//  Created by Admin on 2/17/20.
//

import Foundation
import UIKit

public class BackgroundTaskManager {

    static private(set) var shared: BackgroundTaskManager?

    private var taskId = UIBackgroundTaskIdentifier.invalid
    private var taskIdList = [Int]()

    private let application: UIApplication = UIApplication.shared

    public func mainBackgroundTaskManager() -> BackgroundTaskManager? {
        if BackgroundTaskManager.shared == nil {
            BackgroundTaskManager.shared = BackgroundTaskManager()
        }
        return BackgroundTaskManager.shared
    }

    public func beginNewBackgroundTask() -> UIBackgroundTaskIdentifier {
        var bgTaskId: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        if application.responds(to: #selector(UIApplication.beginBackgroundTask)) {
            bgTaskId = application.beginBackgroundTask(expirationHandler: {() -> Void in
                print("background task %lu expired", bgTaskId)
                self.taskIdList.removeObject(object: bgTaskId)
                self.application.endBackgroundTask(bgTaskId)
                bgTaskId = UIBackgroundTaskIdentifier.invalid
            })
            if self.taskId == UIBackgroundTaskIdentifier.invalid {
                self.taskId = bgTaskId
                print("started master task %lu", self.taskId)
            } else {
                print("started background task %lu", bgTaskId)
                self.taskIdList.append(bgTaskId.rawValue)
            }
        }
        return bgTaskId
    }

    private func endBackgroundTasks() {
        print("end background tasks %lu", self.taskId)
        if application.responds(to: #selector(UIApplication.endBackgroundTask(_:))) {
            let count: Int = self.taskIdList.count
            for _ in 1 ..< count {
                let bgTaskId: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: self.taskIdList[0])
                print("ending background task with id -%lu", bgTaskId)
                self.application.endBackgroundTask(bgTaskId)
                self.taskIdList.remove(at: 0)
            }
            if self.taskIdList.count > 0 {
                NSLog("kept background task id %@", self.taskIdList[0])
            }
            print("kept master background task id %lu", self.taskId)
        }
    }

}

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }

        if index != nil {
            self.remove(at: index!)
        }
    }
    func contains<T: Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
