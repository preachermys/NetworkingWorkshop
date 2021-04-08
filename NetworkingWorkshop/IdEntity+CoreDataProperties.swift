//
//  IdEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

extension IdEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IdEntity> {
        return NSFetchRequest<IdEntity>(entityName: "IdEntity")
    }

    @NSManaged public var elementId: String?
    @NSManaged public var id: String?
    @NSManaged public var position: Int64
    @NSManaged public var training: TrainingEntity?
    @NSManaged public var training2: TrainingEntity?

    func updateFromDict(superId: String, position: Int, dict: [String: String]) {
        elementId = dict["id"]!
        id = dict["id"]! + superId
        self.position = Int64(position)
    }
}
