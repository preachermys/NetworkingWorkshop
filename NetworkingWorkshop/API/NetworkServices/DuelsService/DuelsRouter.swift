//
//  DuelsRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

enum DuelsRouter: APIConfiguration {
    
    case getDuels(userId: String, page: Int)
    case getDuelsStat(userId: String)
    case getDuelGames(userId: String)
    case getDuelsBy(ids: [String])
    case getCompletedDuels(userId: String, page: Int)
    
    case getDuelOpponent(userId: String, duelId: String)
    case createDuelGame(duelId: String, opponentId: String)
    case postDuelGameResult(gameId: String, duelDictionary: [String: Any])
    
    var method: HTTPMethod {
        switch self {
        case .getDuels, .getDuelsStat, .getDuelGames,
             .getDuelsBy, .getCompletedDuels, .getDuelOpponent:
            return .get
        case .postDuelGameResult, .createDuelGame:
            return .post
        }
    }

    var path: String {
        switch self {
        case .getDuels(let userId, _):
            return "v1/users/\(userId)/duels"
        case .getDuelsStat(let userId):
            return "v1/stats/users/\(userId)/duels"
        case .getDuelOpponent(let userId, let duelId):
            return "v1/duels/\(duelId)/user/\(userId)/opponent"
        case .getDuelGames(let userId):
            return "v1/users/\(userId)/duels/games"
        case .getCompletedDuels(let userId, _):
            return "v1/users/\(userId)/duels/games"
        case .getDuelsBy:
            return "v1/duels"
        case .createDuelGame(let duelId, _):
            return "v1/duels/\(duelId)/games"
        case .postDuelGameResult(let gameId, _):
            return "/v1/duels/games/\(gameId)/answers"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getDuels(_, let page):
            return .url([
                "offset": "\(page * 20)", "per_page": 20,
                "sort": ("{\"published_at\": \"desc\"}").utf8
            ])
        case .getDuelGames:
            return .url([
                "filters": ("{\"state\":[\"in_progress\"]}")
            ])
        case .getCompletedDuels(_, let page):
            return .url([
                "offset": "\(page * 20)", "per_page": 20,
                "filters": ("{\"state\":[\"completed\", \"draw\", \"expired\"]}")
            ])
        case .getDuelsBy(let ids):
            return .url([
                "filters": ("{\"id\":[\"" + ids.joined(separator: "\", \"") + "\"]}").utf8
            ])
        case .createDuelGame(_, let opponentId):
            return .body([
                "opponent": opponentId
            ])
        case .postDuelGameResult(_, let duelDict):
            return .body(duelDict)
        case .getDuelsStat, .getDuelOpponent:
            return .body([:])
        }
    }
}
