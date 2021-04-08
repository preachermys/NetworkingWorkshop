//
//  TrainingCategoryEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

extension TrainingCategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingCategoryEntity> {
        return NSFetchRequest<TrainingCategoryEntity>(entityName: "TrainingCategoryEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var position: Int16
    @NSManaged public var published: Date?
    @NSManaged public var trainingsIds: NSSet?
    @NSManaged public var isShareable: Bool

    func updateFromDict(dict: [String: Any]) {
        id = (dict["id"] as? String) ?? ""
        name = (dict["name"] as? String) ?? ""
        position = dict["position"] as? Int16 ?? 0
        isShareable = (dict["is_shareable"] as? Bool) ?? false

        if let dateString = dict["created_at"] as? String {
            published = Date().unixTime(of: dateString)
        } else {
            published = DateFormatter().date(from: "")
        }
        
        if let trainingArray = dict["trainings"] as? [[String: Any]] {
            for (index, tr) in trainingArray.enumerated() {

                let entityDescription = NSEntityDescription.entity(forEntityName: "IdEntity",
                                                                   in: (managedObjectContext)!)

                let managedObject = IdEntity.init(entity: entityDescription!,
                                                             insertInto: managedObjectContext)
                managedObjectContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                managedObject.updateFromDict(superId: id!, position: index, dict: ["id": (tr["id"] as? String) ?? ""])
                addToTrainingsIds(managedObject)
            }
        }
    }

}

// MARK: Generated accessors for trainingsIds
extension TrainingCategoryEntity {

    @objc(addTrainingsIdsObject:)
    @NSManaged public func addToTrainingsIds(_ value: IdEntity)

    @objc(removeTrainingsIdsObject:)
    @NSManaged public func removeFromTrainingsIds(_ value: IdEntity)

    @objc(addTrainingsIds:)
    @NSManaged public func addToTrainingsIds(_ values: NSSet)

    @objc(removeTrainingsIds:)
    @NSManaged public func removeFromTrainingsIds(_ values: NSSet)

}
