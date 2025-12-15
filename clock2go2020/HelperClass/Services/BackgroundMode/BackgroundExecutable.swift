//
//  BackgroundExecutable.swift
//  clock2go2020
//
//  Created by Admin on 3/2/20.
//

import UIKit

class BackgroundExecutable {
    var identifier: UIBackgroundTaskIdentifier
    let function: (() -> Void) -> Void

    init(function: @escaping (_ completion: () -> Void) -> Void) {
        self.function = function
        self.identifier = UIBackgroundTaskIdentifier.invalid
    }

    func execute() {
        let application = UIApplication.shared
        identifier = application.beginBackgroundTask {
            application.endBackgroundTask(self.identifier)
        }
        function(endBackgroundTask)
    }

    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(identifier)
    }
}
