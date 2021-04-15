//
//  CardEntity+CoreDataProperties.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

extension CardEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardEntity> {
        return NSFetchRequest<CardEntity>(entityName: "CardEntity")
    }

    @NSManaged public var descr: String?
    @NSManaged public var id: String?
    @NSManaged public var postId: String?
    // HOTFIX
    @NSManaged public var taskId: String?
    //
//    @NSManaged public var image: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var isCommentSend: Bool
    @NSManaged public var isFavorited: Bool
    @NSManaged public var isLiked: Bool
    @NSManaged public var likesCount: Int16
    @NSManaged public var favoritesCount: Int16
    @NSManaged public var published: Date?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var tags: String?
//    @NSManaged public var feedBack: FeedBackEntity?
    @NSManaged public var isShareable: Bool
    @NSManaged public var referralSharesCount: Int16
    @NSManaged public var isShare: Bool
    @NSManaged public var favoriteCreated: Date?
    @NSManaged public var images: [NSString]?
    
    func updateFromDict(dict: [String: Any]) {
        if let entityId = dict["entity_id"] as? String {
            self.id = entityId
        }
        if let id = dict["id"] as? String {
            self.id = id
        }
        if let name = dict["name"] as? String {
            self.title = name
        }
        descr = (dict["description"] as? String) ?? ""
                
        if let images = dict["image"] as? [String: Any] {
            self.images = MediaFormatService.getAvailableImages(from: images) as [NSString]
        }
                
        if let favoritesCount = dict["favorites_count"] as? Int16 {
            self.favoritesCount = favoritesCount
        }
        if let likesCount = dict["likes_count"] as? Int16 {
            self.likesCount = likesCount
        }

        if let dateString = dict["published_at"] as? String {
            published = Date().unixTime(of: dateString)
        }

        if let status = dict["status"] as? String {
            self.status = status
        }
        
        if let isShareable = dict["is_shareable"] as? Bool {
            self.isShareable = isShareable
        }
        
        if let isShareValue = dict["is_share"] as? Bool {
            isShare = isShareValue
        }
        if let sharesCount = dict["referral_shares_count"] as? Int16 {
            referralSharesCount = sharesCount
        }

        tags = ""
        if let tagsList = (dict["tags"] as? [String]) {
            for tag in tagsList {
                if (self.tags?.isEmpty)! {
                    self.tags? += "\(tag)"
                } else {
                    self.tags? += " \(tag)"
                }
            }
        }
        if let type = dict["type"] as? String {
            self.type = type
        }
    }
}

