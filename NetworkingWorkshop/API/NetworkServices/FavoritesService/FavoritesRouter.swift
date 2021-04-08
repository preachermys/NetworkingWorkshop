//
//  FavoritesRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

enum FavoritesRouter: APIConfiguration {
    enum FavoriteRequestType: String {
        case training = "trainings"
        case post = "posts"
        case duel = "duels"
    }
    
    enum ShareRequestType: String {
        case training = "trainings"
        case card = "cards"
        case duel = "duels"
        case category = "category"
    }

    case getFavoritesCount(userId: String)
    case getFavorites(type: FavoriteRequestType, userId: String)
    
    case addToFavorite(type: FavoriteRequestType, userId: String, entityId: String)
    case removeFavorite(type: FavoriteRequestType, userId: String, entityId: String)
    
    case getShareLink(type: ShareRequestType, entityId: String)
    
    var method: HTTPMethod {
        switch self {
        case .getFavoritesCount, .getFavorites, .getShareLink:
            return .get
        case .addToFavorite:
            return .post
        case .removeFavorite:
            return .delete
        }
    }

    var path: String {
        switch self {
        case .getFavoritesCount(let userId):
            return "v1/users/\(userId)/favorites/counts"
        case .getFavorites(let type, let userId):
            return "v1/users/\(userId)/favorites/\(type.rawValue)"
        case .addToFavorite(let type, let userId, _):
            return "v1/users/\(userId)/favorites/\(type.rawValue)"
        case .removeFavorite(let type, let userId, let postId):
            return "v1/users/\(userId)/favorites/\(type.rawValue)/\(postId)"
        case .getShareLink(let type, let entityId):
            switch type {
            case .category:
                return "v1/trainings/\(type.rawValue)/\(entityId)/share"
            default:
                return "v1/\(type.rawValue)/\(entityId)/share"
            }
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getFavoritesCount, .getFavorites, .removeFavorite, .getShareLink:
            return .body([:])
        case .addToFavorite(_, _, let entityId):
            return .body([
                "entity_id": entityId
            ])
        }
    }
}
