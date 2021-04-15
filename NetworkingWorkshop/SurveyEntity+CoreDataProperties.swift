//
//  SurveyEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import Foundation
import CoreData

extension SurveyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SurveyEntity> {
        return NSFetchRequest<SurveyEntity>(entityName: "SurveyEntity")
    }

    @NSManaged public var starsCount: Int16
    @NSManaged public var isWithComments: Bool
    
    func updateFromDict(dict: [String: Any], special: [String: Any]) {
        super.updateFromDict(dict: dict)
        
        if let isWithComments = special["is_with_comments"] as? Bool {
            self.isWithComments = isWithComments
        }
    }
    
//    var isAnswered: Bool {
//        var hasComment = false
//        reports.forEach { (report) in
//            if let body = report.body, !body["comment"].isNil {
//                hasComment = true
//            }
//        }
//        return hasComment
//    }
//
//    var markCount: Int {
//        var mark = 0
//
//        reports
//            .sorted(by: { $0.timestamp! > $1.timestamp! })
//            .forEach({ if let body = $0.body, let grade = body["grade"] as? Int {
//                mark = grade
//                }
//            })
//        return mark
//    }
}
