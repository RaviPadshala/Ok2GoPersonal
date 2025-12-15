//
//  AdditionalTask+CoreDataProperties.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 31.08.2022.
//
//

import Foundation
import CoreData

extension AdditionalTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdditionalTask> {
        return NSFetchRequest<AdditionalTask>(entityName: "AdditionalTask")
    }

    @NSManaged public var taskId: String?
    @NSManaged public var taskName: String?
    @NSManaged public var projectId: Int16
    @NSManaged public var projectName: String?
    @NSManaged public var empId: Int64

}
