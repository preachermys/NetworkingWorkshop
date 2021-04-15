//
//  CaseCardEntity+CoreDataClass.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import Foundation
import CoreData

@objc(CaseCardEntity)
public class CaseCardEntity: CardEntity {

    class func createOrReuseEntity(id: String) -> CaseCardEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaseCardEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        if let results = try? FeedService.shared.privateMOC.fetch(fetchRequest),
            results.count > 0,
            let entity = results.first as? CaseCardEntity {
            return entity
        }
        
        if let newObject = NSEntityDescription.insertNewObject(forEntityName: "CaseCardEntity",
                                                               into: FeedService.shared.privateMOC) as? CaseCardEntity {
            return newObject
        }
        
        return nil
    }
}
