//
//  DuelsManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

final class DuelsManager: CommonNetworkManager {
    
    // MARK: - Get duels
    
    func getDuels(by page: Int, completion: @escaping ([DuelEntity]) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = DuelsRouter.getDuels(userId: userId, page: page).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dataList = data["data"] as? [[String: Any]] {

                    completion(dataList.map { CoreDataObjectFabric.createDuelEntity(from: $0) })
                }
            case .failure:
                completion([])
            }
        }
    }
    
    func getDuels(by ids: [String], completion: @escaping ([DuelEntity]) -> Void) {
        let request = DuelsRouter.getDuelsBy(ids: ids).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dataList = data["data"] as? [[String: Any]] {
                    
                    let duels = dataList.map { CoreDataObjectFabric.createDuelEntity(from: $0) }
                    
                    CoreDataObjectFabric.deleteDuels(with: dataList)
                
                    completion(duels)
                }
            case .failure:
                completion([])
            }
        }
    }
    
    // MARK: - Get duels stat
    
//    func getDuelsStat(completion: @escaping (DuelStatModel?) -> Void) {
//        guard let userId = UserModel.shared.userId else { return }
//
//        let request = DuelsRouter.getDuelsStat(userId: userId).asURL()
//
//        session.request(request).validate().responseDecodable(of: DuelStatResp.self) { response in
//
//            switch response.result {
//            case .success(let duelStat):
//                if let data = duelStat.data {
//                    completion(data)
//                }
//            case .failure:
//                completion(nil)
//            }
//        }
//    }
    
    // MARK: - Get duel opponent
    
//    func getDuelOpponent(duelId: String, completion: @escaping (User?) -> Void) {
//        guard let userId = UserModel.shared.userId else { return }
//
//        let request = DuelsRouter.getDuelOpponent(userId: userId, duelId: duelId).asURL()
//
//        session.request(request).validate().responseDecodable(of: DuelOpponentResp.self) { response in
//
//            switch response.result {
//            case .success(let duelOpponent):
//                if let data = duelOpponent.data {
//                    completion(data)
//                }
//            case .failure:
//                completion(nil)
//            }
//
//        }
//    }
    
    // MARK: - Get duel games
    
//    func getDuelGames(completion: @escaping ([DuelGameModel]) -> Void) {
//        guard let userId = UserModel.shared.userId else { return }
//
//        let request = DuelsRouter.getDuelGames(userId: userId)
//
//        session.request(request).validate().responseDecodable(of: ActiveDuelResp.self) { response in
//
//            switch response.result {
//            case .success(let activeDuels):
//                if let data = activeDuels.data {
//                    completion(data)
//                }
//            case .failure:
//                completion([])
//            }
//
//        }
//    }
    
    // MARK: - Get completed duels
    
//    func getCompletedDuels(page: Int, completion: @escaping ([DuelGameModel]) -> Void) {
//        guard let userId = UserModel.shared.userId else { return }
//
//        let request = DuelsRouter.getCompletedDuels(userId: userId, page: page).asURL()
//
//        session.request(request).validate().responseDecodable(of: ActiveDuelResp.self) { response in
//
//            switch response.result {
//            case .success(let completedDuels):
//                if let data = completedDuels.data {
//                    completion(data)
//                }
//            case .failure:
//                completion([])
//            }
//
//        }
//    }
    
    // MARK: - Create duel game
    
//    func createDuelGame(duelId: String, opponentId: String, completion: @escaping (DuelGameModel?) -> Void) {
//        let request = DuelsRouter.createDuelGame(duelId: duelId, opponentId: opponentId)
//
//        session.request(request).validate().responseDecodable(of: DuelGameModel.self) { response in
//
//            switch response.result {
//            case .success(let duelGame):
//                completion(duelGame)
//            case .failure:
//                completion(nil)
//            }
//        }
//
//    }
    
    // MARK: - Post duel game result
    
//    func postDuelGameResult(gameId: String, duelDictionary: [String: Any], completion: @escaping () -> ()) {
//        let request = DuelsRouter.postDuelGameResult(gameId: gameId, duelDictionary: duelDictionary)
//        
//        session.request(request).validate().response { _ in
//            completion()
//        }
//    }
}
