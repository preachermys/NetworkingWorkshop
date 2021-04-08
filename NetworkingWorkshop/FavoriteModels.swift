//
//  FavoriteModels.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation

struct FavoriteModel: Codable {
    let data: [FavoriteModelData]
}

struct FavoriteModelData: Codable {
    let typeFromServer: String?
    let entityId: String?
    let cardId: String?
    let favoritesCount: Int?
    let likesCount: Int?
    let created: String?
    let type: FavoriteType
    
    enum CodingKeys: String, CodingKey {
        case entityId = "entity_id"
        case cardId = "card_id"
        case favoritesCount = "favorites_count"
        case likesCount = "likes_count"
        case created = "created_at"
        case typeFromServer = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        entityId = try values.decodeIfPresent(String.self, forKey: .entityId)
        cardId = try values.decodeIfPresent(String.self, forKey: .cardId)
        favoritesCount = try values.decodeIfPresent(Int.self, forKey: .favoritesCount)
        likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        typeFromServer = try values.decodeIfPresent(String.self, forKey: .typeFromServer)
        type = FavoriteType(string: typeFromServer ?? "")
    }
}
