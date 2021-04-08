//
//  DuelEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

extension DuelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DuelEntity> {
        return NSFetchRequest<DuelEntity>(entityName: "DuelEntity")
    }

    @NSManaged public var hasBlock: Bool
    @NSManaged public var timeLimit: Int64
    @NSManaged public var questions: NSSet?
    @NSManaged public var createdAt: String?
    @NSManaged public var publishedAt: String?

    func updateFromDict(dictionary: [String: Any]) {
        
        createdAt = dictionary["created_at"] as? String
        publishedAt = dictionary["published_at"] as? String
        timeLimit = dictionary["time_limit"] as? Int64 ?? 0

        try? DuelsService.shared.privateMOC.save()
        let blocksArray = (dictionary["blocks"] as? [[String: Any]])  ?? [[:]]
        
        for (index, blockDict) in blocksArray.enumerated() {
            guard let type = blockDict["type"] as? String,
                let safeAnswers = blockDict["answers"] as? [[String: Any]],
                let id = blockDict["id"] as? String else {
                    
                break
            }
        }
        super.updateFromDict(dict: dictionary)
    }
}
