//
//  UniversallinkManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

final class UniversallinkManager: CommonNetworkManager {
    struct Errors: Codable {
        let errors: UniversalLinkErrorType
        
        struct UniversalLinkErrorType: Codable {
            let type: String
        }
    }
     
    private let userManager = UserManager()
    
    // MARK: - Post universal link
    
    func postUniversalLink(url: String, completion: @escaping (UniversalLinkModel?, LinkError?) -> Void) {
        let request = UniversallinkRouter.postUniversalLink(url: url)
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any] {
                    if let dict = data["data"] as? [String: Any] {
                    
                        completion(UniversalLinkModel(dict: dict), nil)
                    } else if let error = data["errors"] as? [String: Any],
                        let type = error["type"] as? String {
                        
                        completion(nil, LinkError(statusCode: response.response?.statusCode ?? 0,
                                                  type: ErrorDescription(string: type)))
                    }
                }
            case .failure:
                guard let errorType = try? JSONDecoder().decode(Errors.self, from: response.data ?? Data()) else {
                    return completion(nil, nil)
                }
                
                completion(nil, LinkError(statusCode: response.response?.statusCode ?? 0,
                                          type: ErrorDescription(string: errorType.errors.type)))
            }
        }
    }
    
    // MARK: - Post universal link autologin
    
    func postUniversalLinkAutoLogin(url: String, baseURL: String, completion: @escaping () -> ()) {
        let request = UniversallinkRouter.postUniversalLinkAutoLogin(url: url, baseURL: baseURL)
        
        session.request(request).validate().responseJSON { [weak self] response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dict = data["data"] as? [String: Any],
                    let expires = dict["expires_in"] as? Double, expires > 0 {
                    
                    if let url = UserDefaults.standard.string(forKey: "base_url"), !url.isEmpty {
                        if !UserModel.shared.pushToken.isEmpty {
                            self?.userManager.removePushToken(pushToken: UserModel.shared.pushToken) {}
                        }
                        UserModel.shared.clearUser()
                    }
                    
                    if let token = dict["access_token"] as? String {
                        KeychainService.shared.save(string: token, with: .token)
                        
                        if let refreshToken = dict["refresh_token"] as? String {
                            KeychainService.shared.save(string: refreshToken, with: .refreshToken)
                        }
                        
                        let clearUrl = String(baseURL.deletingPrefix("api-"))
                        UserDefaults.standard.set("https://" + clearUrl, forKey: "base_url")
                        
                        completion()
                    }
                }
            case .failure:
                completion()
            }
        }
    }
}
