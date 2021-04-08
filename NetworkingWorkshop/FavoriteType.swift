//
//  FavoriteType.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData

enum FavoriteType: String {

    case training = "ТРЕНИРОВКА"
    case post = "ПОСТ"
    case duel = "ДУЭЛЬ"

    init(string: String) {
        switch string {
        case "training":
            self = .training
        case "post":
            self = .post
        case "duel":
            self = .duel
        default:
            self = .training
        }
    }

    func stringValue() -> String {
        switch self {
        case .training :
            return "training"
        case .post:
            return "post"
        case .duel:
            return "duel"
        }
    }
}
extension FavoriteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEntity> {
        return NSFetchRequest<FavoriteEntity>(entityName: "FavoriteEntity")
    }

    @NSManaged public var type: String?
    @NSManaged public var entityId: String?
    @NSManaged public var cardId: String?
    @NSManaged public var favoritesCount: Int16
    @NSManaged public var likesCount: Int16
    @NSManaged public var created: Date?

    func updateFromDict(dict: [String: Any]) {
        
        // TODO: Временное решение, пока сервер
        // не приведет сущности к единому виду.
        if let id = dict["id"] as? String {
            self.entityId = id
        }
        if let id = dict["entity_id"] as? String {
            self.entityId = id
        }
        if let cardId = dict["card"] as? String {
            self.cardId = cardId
        }
        if let cardId = dict["card_id"] as? String {
            self.cardId = cardId
        }
        if let dateString = dict["created_at"] as? String {
            created = Date().unixTimeForFavorites(from: dateString)
        }
        if let favoritesCount = dict["favorites_count"] as? Int16 {
            self.favoritesCount = favoritesCount
        }
        if let likesCount = dict["likes_count"] as? Int16 {
            self.likesCount = likesCount
        }
    }
}

