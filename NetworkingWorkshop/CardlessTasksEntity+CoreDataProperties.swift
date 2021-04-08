//
//  CardlessTasksEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 01.04.2021.
//

import CoreData
import Foundation

extension CardlessTasksEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardlessTasksEntity> {
        return NSFetchRequest<CardlessTasksEntity>(entityName: "CardlessTasksEntity")
    }
    
    @NSManaged public var overdueCount: Int16
    @NSManaged public var inProgressCount: Int16
    @NSManaged public var completedCount: Int16
    
    func updateFromDict(dict: [String: Any]) {
        guard let meta = dict["meta"] as? [String: Int16] else {
            return
        }
        
        overdueCount = meta["overdue"] ?? 0
        inProgressCount = meta["in_progress"] ?? 0
        completedCount = meta["completed"] ?? 0
    }
}
