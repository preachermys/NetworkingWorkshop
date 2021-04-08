//
//  TrainingEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

extension TrainingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingEntity> {
        return NSFetchRequest<TrainingEntity>(entityName: "TrainingEntity")
    }

    @NSManaged public var estipationTime: Int16
    @NSManaged public var progress: Float
    @NSManaged public var cardIdsLocal: String?
    @NSManaged public var cardsCompleted: Int32
    @NSManaged public var rating: Double
    @NSManaged public var ratingCount: Int16
    
    var cardIds: [String] {
        guard let ids = cardIdsLocal else {
            return []
        }
        return ids
            .trimmingCharacters(in: CharacterSet(charactersIn: " "))
            .components(separatedBy: " ")
    }
    
    var markCount: Int {
        var mark = 0
        return mark
    }
    
    func updateFromDict(dict: [String: Any], special: [String: Any]?) {
        if let rating = dict["rating"] as? Double,
            let ratingCount = dict["rating_count"] as? Int16 {
            
            self.rating = rating
            self.ratingCount = ratingCount
        }

        estipationTime = (dict["estimation_time"] as? Int16) ?? 0
        self.cardIdsLocal = ""
        if let cardsArray = dict["cards"] as? [[String: String]] {
            for tr in cardsArray {
                if let cardId = tr["id"] {
                    self.cardIdsLocal? += " \(cardId)"
                }
            }
        }
    }
}

