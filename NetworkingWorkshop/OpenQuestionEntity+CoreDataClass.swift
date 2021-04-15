//
//  OpenQuestionEntity+CoreDataClass.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import Foundation
import CoreData

@objc(OpenQuestionEntity)
public class OpenQuestionEntity: CardEntity {
    
    class func createOrReuseEntity(id: String) -> OpenQuestionEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OpenQuestionEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        if let results = try? FeedService.shared.privateMOC.fetch(fetchRequest),
            results.count > 0,
            let entity = results.first as? OpenQuestionEntity {
            return entity
        }
        
        if let newObject = NSEntityDescription.insertNewObject(forEntityName: "OpenQuestionEntity",
                                                               into: FeedService.shared.privateMOC) as? OpenQuestionEntity {
            return newObject
        }
        
        return nil
    }
}
