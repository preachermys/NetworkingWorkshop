//
//  TaskEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 01.04.2021.
//

import Foundation
import CoreData

extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var duelId: String?
    @NSManaged public var cardId: String?
    @NSManaged public var trainingId: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isOverdue: Bool
    @NSManaged public var completedAt: Date?
    @NSManaged public var createdAt: Date?
    
    func updateFromDict(dict: [String: Any]) {
        id = dict["id"] as? String
        duelId = (dict["duel"] as? [String: String])?["id"]
        cardId = (dict["card"] as? [String: String])?["id"]
        trainingId = (dict["training"] as? [String: String])?["id"]
        isCompleted = (dict["is_completed"] as? Bool)!
        isOverdue = (dict["is_overdue"] as? Bool)!

        if let dateString = dict["due_date"] as? String {
            dueDate = Date().unixTime(of: dateString)
        }
        
        if let dateString = dict["completed_at"] as? String {
            completedAt = Date().unixTime(of: dateString)
        }
        
        if let dateString = dict["created_at"] as? String {
            createdAt = Date().unixTime(of: dateString)
        }
    }
}

