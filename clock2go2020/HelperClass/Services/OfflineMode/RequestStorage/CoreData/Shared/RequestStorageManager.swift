//
//  RequestStorageManager.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 18.08.2020.
//

import UIKit
import CoreData

open class OfflineModeCoreDataStorage {

    public static let sharedInstance = OfflineModeCoreDataStorage()

    // MARK: - Core Data Stack

    /// Managed object context of current Manager.
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "RequestSavedModel", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }

        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "RequestSavedModel.sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
        } catch {
            do {
                try fileManager.removeItem(at: persistentStoreURL)
            } catch {
                fatalError("Unable to Load Persistent Store")
            }
        }

        return persistentStoreCoordinator
    }()

    // MARK: - NSManagedObject Contexts
    open class func mainQueueContext() -> NSManagedObjectContext {
        return self.sharedInstance.managedObjectContext
    }
}
