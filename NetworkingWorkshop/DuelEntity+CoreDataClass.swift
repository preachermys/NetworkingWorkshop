//
//  DuelEntity+CoreDataClass.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

@objc(DuelEntity)
public class DuelEntity: CardEntity {
    class func createOrReuseEntity(id: String) -> DuelEntity {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DuelEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        if let results = try? DuelsService.shared.privateMOC.fetch(fetchRequest) {
            if results.count > 0 {
                return (results.first as? DuelEntity)!
            }
        }
        return (NSEntityDescription.insertNewObject(forEntityName: "DuelEntity",
                                                    into: DuelsService.shared.privateMOC) as? DuelEntity)!
    }
}
