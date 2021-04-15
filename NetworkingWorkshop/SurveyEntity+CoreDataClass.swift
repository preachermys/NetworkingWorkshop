//
//  SurveyEntity+CoreDataClass.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import Foundation
import CoreData

@objc(SurveyEntity)
public class SurveyEntity: CardEntity {

    class func createOrReuseEntity(id: String) -> SurveyEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SurveyEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        if let results = try? FeedService.shared.privateMOC.fetch(fetchRequest),
            results.count > 0,
            let entity = results.first as? SurveyEntity {
            return entity
        }
        
        if let newObject = NSEntityDescription.insertNewObject(forEntityName: "SurveyEntity",
                                                               into: FeedService.shared.privateMOC) as? SurveyEntity {
            return newObject
        }
        
        return nil
    }
}
