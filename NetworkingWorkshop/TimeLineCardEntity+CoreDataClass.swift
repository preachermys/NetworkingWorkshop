//
//  TimeLineCardEntity+CoreDataClass.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

@objc(TimeLineCardEntity)
public class TimeLineCardEntity: CardEntity {

    class func createOrReuseEntity(id: String) -> TimeLineCardEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeLineCardEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        if let results = try? FeedService.shared.privateMOC.fetch(fetchRequest),
            results.count > 0,
            let entity = results.first as? TimeLineCardEntity {
            return entity
        }
        
        if let newObject = NSEntityDescription.insertNewObject(forEntityName: "TimeLineCardEntity",
                                                               into: FeedService.shared.privateMOC) as? TimeLineCardEntity {
            return newObject
        }
        
        return nil
    }
}
