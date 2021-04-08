//
//  FavoritesManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

final class FavoritesManager: CommonNetworkManager {
    
    // MARK: - Get favorites count
    
    func getFavoritesCount(completion: @escaping (Int) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = FavoritesRouter.getFavoritesCount(userId: userId).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any] {
                    if let dataList = data["data"] as? [String: Any],
                        let posts = dataList["posts"] as? Int,
                        let trainings = dataList["trainings"] as? Int,
                        let duels = dataList["duels"] as? Int {
                        
                        completion(posts + trainings + duels)
                    }
                }
            case .failure:
                completion(0)
            }
        }
    }
    
    // MARK: - Get favorites
    
    func getFavorites(_ type: FavoritesRouter.FavoriteRequestType, completion: @escaping ([FavoriteModelData]) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = FavoritesRouter.getFavorites(type: type, userId: userId).asURL()
        
        session.request(request).validate().responseDecodable(of: FavoriteModel.self) { response in
            
            switch response.result {
            case .success(let response):
                completion(response.data)
            case .failure:
                completion([])
            }
        }
    }
    
    // MARK: - Add to favorite
    
    func addToFavorite(_ type: FavoritesRouter.FavoriteRequestType, entityId: String, completion: @escaping ([String: Any]) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = FavoritesRouter.addToFavorite(type: type, userId: userId, entityId: entityId)
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any] {
                    completion(data)
                }
            case .failure:
                completion([:])
            }
        }
    }
    
    // MARK: - Remove favorite
    
    func removeFavorite(_ type: FavoritesRouter.FavoriteRequestType, entityId: String) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = FavoritesRouter.removeFavorite(type: type, userId: userId, entityId: entityId)
        
        session.request(request).validate().resume()
    }
    
    // MARK: - Get share link
    
    func getShareLink(_ type: FavoritesRouter.ShareRequestType, entityId: String, completion: @escaping (String?, LinkError?) -> Void) {
        let request = FavoritesRouter.getShareLink(type: type, entityId: entityId).asURL()
        
        session.request(request).validate().responseJSON { response in
            self.parseLinkResponse(response: response, completion: completion)
        }
    }
    
    private func parseLinkResponse(response: AFDataResponse<Any>, completion: (String?, LinkError?) -> Void) {
        guard let dictionary = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: AnyObject] else {
            return
        }
        
        guard let data = dictionary["data"] as? [String: Any],
            let shareUrl = data["url"] as? String else {
                guard let data = dictionary["errors"] as? [String: Any],
                    let type = data["type"] as? String else { return }
                completion(nil, LinkError(statusCode: response.response?.statusCode ?? 0,
                                          type: ErrorDescription(string: type)))
                return
        }
        completion(shareUrl, nil)
    }
}
