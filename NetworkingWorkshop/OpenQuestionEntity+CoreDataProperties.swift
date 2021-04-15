//
//  OpenQuestionEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import Foundation
import CoreData

extension OpenQuestionEntity {
    
    @NSManaged public var isWithComments: Bool

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OpenQuestionEntity> {
        return NSFetchRequest<OpenQuestionEntity>(entityName: "OpenQuestionEntity")
    }
    
    func updateFromDict(dict: [String: Any], special: [String: Any]) {
        super.updateFromDict(dict: dict)
        
        if let isWithComments = special["is_with_comments"] as? Bool {
            self.isWithComments = isWithComments
        }
    }
}
