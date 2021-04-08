//
//  FeedRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

enum FeedRouter: APIConfiguration {

    case getFeed(
        userId: String,
        page: Int,
        timestamp: Int,
        searchTags: [String]?,
        searchString: String?,
        types: [FeedCardType]?
    )
    
    case getCards(cardIds: [String]?)
    case getPosts(userId: String, by: [String])
    case getTags(userId: String, page: Int, searchString: String)
    
    var method: HTTPMethod {
        switch self {
        case .getFeed, .getCards, .getPosts, .getTags:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getFeed(let userId, _, _, _, _, _):
            return "v1/users/\(userId)/feed"
        case .getCards:
            return "v1/cards"
        case .getPosts(let userId, _):
            return "v1/users/\(userId)/feed"
        case .getTags(let userId, _, _):
            return "v1/users/\(userId)/feed/tags"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getFeed(_, let page, let timeStemp, let tags, let searchString, let types):
            var body: [String: Any] = [
                "offset": "\(page * 20)",
                "per_page": 20
            ]
            
            if let searchString = searchString {
                body["timestamp"] = timeStemp
                body["search"] = searchString
                
                return .url(body)
            }
            
            if let tags = tags {
                body["timestamp"] = timeStemp
                body["filters"] = ("{\"tags\":[\"" + tags.joined(separator: "\", \"") + "\"]}").utf8
                
                return .url(body)
            }
            
            if let types = types {
                let typesString = types.map { $0.rawValue.lowercased() }
                body["filters"] = ("{\"types\":[\"" + typesString.joined(separator: "\", \"") + "\"]}").utf8
                
                return .url(body)
            }
            
            return .url(body)
        case .getCards(let cardIds):
            if let cardsId = cardIds {
                if cardsId.isEmpty {
                    return .url(["filters": ("{\"id\":[]}").utf8])
                }
                return .url([
                    "filters": ("{\"id\":[\"" + cardsId.joined(separator: "\", \"") + "\"]}").utf8,
                    "per_page": 20])
            }
            return .url(["per_page": 20])
        case .getPosts(_, let ids):
            return .url(["sort": ("{\"created_at\":\"desc\"}").utf8,
                         "filters": ("{\"posts\":[\"" + ids.joined(separator: "\", \"") + "\"]}").utf8])
        case .getTags(_, let page, let searchString):
            return .url([
                "offset": "\(page * 20)",
                "per_page": 20,
                "search": searchString
            ])
        }
    }
}
