//
//  TimeLineCardEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

extension TimeLineCardEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeLineCardEntity> {
        return NSFetchRequest<TimeLineCardEntity>(entityName: "TimeLineCardEntity")
    }
    
    @NSManaged public var blocks: NSSet?
    
    func updateFromDict(dict: [String: Any], special: [String: Any]) {
       
        if let blocks = self.blocks {
            self.removeFromBlocks(blocks)
        }
        try? FeedService.shared.privateMOC.save()
        
//        if let blocksArray = (special["blocks"] as? [[String: Any]]) {
//            for (index, blockDict) in blocksArray.enumerated() {
//                 let managedObject = TimeLineBlockEntity.createOrReuseEntity(id: (blockDict["id"] as? String)!)
//                managedObject.updateFromDict(index: index, dict: blockDict)
//                addToBlocks(managedObject)
//            }
//        }
        super.updateFromDict(dict: dict)
    }
}

// MARK: Generated accessors for blocks
extension TimeLineCardEntity {
    
//    @objc(addBlocksObject:)
//    @NSManaged public func addToBlocks(_ value: TimeLineBlockEntity)
//
//    @objc(removeBlocksObject:)
//    @NSManaged public func removeFromBlocks(_ value: TimeLineBlockEntity)
    
    @objc(addBlocks:)
    @NSManaged public func addToBlocks(_ values: NSSet)
    
    @objc(removeBlocks:)
    @NSManaged public func removeFromBlocks(_ values: NSSet)
    
}
