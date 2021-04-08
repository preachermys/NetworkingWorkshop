//
//  Interceptor+PostRefreshToken.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

extension RequestInterceptor {
    func postRefreshToken(completionWithError: @escaping ((Error?)) -> Void, completionAccessToken: @escaping (String) -> Void) {
        let json: [String: String] = ["grant_type": "refresh_token",
                                      "refresh_token": KeychainService.shared.load(with: .refreshToken),
                                      "client_id": NetworkConstants.clientId]
        
        var refreshTokenUrl: String = ""
        if let url = UserDefaults.standard.string(forKey: "base_url") {
            refreshTokenUrl = clearAuthBaseURL(baseURL: url)
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let listUrlString = refreshTokenUrl + "oauth/token"
        let myUrl = URL(string: listUrlString)
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        session.dataTask(with: request) { (data, resp, error) in
            guard let data = data, error == nil else {
                completionWithError((error))
                return
            }
            guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                if let code = (resp as? HTTPURLResponse)?.statusCode, ErrorCodes(code: code) == .unAuthorized {
                    completionWithError(AuthError(code: code, reason: .userBlocked))
                } else {
                    completionWithError(CookiesError.noCookies)
                }
                return
            }
            
            guard let token = dictionary["access_token"] as? String,
                let refreshtoken = dictionary["refresh_token"] as? String else {
                    guard let error = dictionary["errors"]?["authentication"] as? String,
                        error == "user_is_blocked" else {
                            completionWithError(nil)
                            LogoutService.shared.logout()
                            return
                    }
                    MainThread.performOn(async: true, execute: {
//                        AlertService.showBlockedUserAlert(completion: {
                            LogoutService.shared.logout()
//                        })
                    })
                    return
            }
            
            KeychainService.shared.save(string: token, with: .token)
            KeychainService.shared.save(string: refreshtoken, with: .refreshToken)

            completionAccessToken(token)
            }.resume()
    }
    
    private func clearAuthBaseURL(baseURL: String) -> String {
        if baseURL.contains("http://") {
            return "http://oauth-" + baseURL.replacingOccurrences(of: "http://", with: "")
        } else if baseURL.contains("https://") {
            return "https://oauth-" + baseURL.replacingOccurrences(of: "https://", with: "")
        }
        return ""
    }
}
