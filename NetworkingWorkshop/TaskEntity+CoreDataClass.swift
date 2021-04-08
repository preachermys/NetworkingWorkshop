//
//  TaskEntity+CoreDataClass.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {
    public var card: CardEntity?
    
    class func createOrReuseEntity(id: String) -> TaskEntity {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let context = TasksService.shared.privateMOC
        
        if let results = try? context.fetch(fetchRequest),
            results.count > 0,
            let entity = results.first as? TaskEntity {
            return entity
        }
        
        let newObject = NSEntityDescription.insertNewObject(forEntityName: "TaskEntity", into: context) as? TaskEntity
        return newObject!
    }

}
