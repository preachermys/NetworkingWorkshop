//
//  PostModel.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation

class PostModel {
    var id: String
    var authorId: String
    var cardIds: [String]
    var favoritesCount: Int
    var likesCount: Int
    var published: Int
    var card: CardEntity?
    var createdAt: Date
    var deletedAt: Date?
    var isDeleted: Bool?
    var publishAt: Date
    var isShareable: Bool = false
    var referralSharesCount: Int = 0
    var isShare: Bool = false
    var isLiked: Bool = false
    var isFavorited: Bool = false

    init(dict: [String: Any]) {
 
        id = dict["id"] as? String ?? ""
        if let plainAuthorId = dict["author"] as? String {
            authorId = plainAuthorId
        } else if let author = dict["author"] as? [String: String], let id = author["id"] {
            authorId = id
        } else {
            authorId = ""
        }
        if let isShareEnable = dict["is_shareable"] as? Bool {
            isShareable = isShareEnable
        }
        if let isShareValue = dict["is_share"] as? Bool {
            isShare = isShareValue
        }
        if let sharesCount = dict["referral_shares_count"] as? Int {
            referralSharesCount = sharesCount
        }

        cardIds = []
        if let cardIdsLocal = (dict["card"] as? [[String: Any]]) {
            cardIds = cardIdsLocal.compactMap({ $0["id"] as? String })
        } else if let plainCardIds = (dict["card"] as? String) {
            cardIds.append(plainCardIds)
        }
        
        favoritesCount = dict["favorites_count"] as? Int ?? 0
        likesCount = dict["likes_count"] as? Int ?? 0
        
        publishAt = Date()
        published = 0
        if let publish = (dict["published_at"] as? [String: Any])?["timestamp"] as? Int {
            published = publish
        }
        if let plainPublishAt = dict["publish_at"] as? Date {
            publishAt = plainPublishAt
        }

        createdAt = dict["created_at"] as? Date ?? Date()
        deletedAt = dict["deleted_at"] as? Date
        isDeleted = ((dict["is_deleted"] as? Int) ?? 0) == 1 ? true : false
    }
}
