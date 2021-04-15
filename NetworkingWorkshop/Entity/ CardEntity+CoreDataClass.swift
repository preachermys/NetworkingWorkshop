//
//   CardEntity+CoreDataClass.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

@objc(CardEntity)
public class CardEntity: NSManagedObject {
//    var reports = [ReportModel]()
    var cardsFinishedIds = [String]()
    var isRequiredPropertyExist: Bool = false
}

extension CardEntity {
    func setRequiredProperty(by parameter: Any?) {
        isRequiredPropertyExist = parameter != nil
    }
    
    func setRequiredPropertyExplicit(isEmpty: Bool?) {
        isRequiredPropertyExist = !(isEmpty ?? true)
    }
}
