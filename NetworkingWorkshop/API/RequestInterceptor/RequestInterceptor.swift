//
//  RequestInterceptor.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

final class RequestInterceptor: SessionDelegate, Alamofire.RequestInterceptor {

    private var retriedRequests: [String: Int] = [:]
    private var tokenRequested: Bool = false
    
    var tempToken: String = ""

    private init() { }
    static let shared = RequestInterceptor()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(createEnvironemtBaseURL()) == true else {
            return completion(.success(urlRequest))
        }
            
        var urlRequest = urlRequest
        
        if KeychainService.shared.load(with: .token) != "" {
            urlRequest.setValue("Bearer " + KeychainService.shared.load(with: .token),
                                forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        } else {
            urlRequest.setValue("Bearer " + tempToken,
                                forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }

        urlRequest.setValue("1.12", forHTTPHeaderField: NetworkConstants.xApiVersion)
        
        completion(.success(urlRequest))
    }
}

// MARK: - Retrier

extension RequestInterceptor {
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard !tokenRequested else {
            return completion(.retryWithDelay(3))
        }
        
        // MARK: - this check needs if the server didn't find the team on the server, we get 401 in response.
        // obviously it's not correct, but the back-end have no enough time to fix it
        if ErrorCodes(code: request.response?.statusCode ?? 0) == .unAuthorized,
           isTeamsRequest(request: request) {
            return completion(.doNotRetry)
        }
        
        if ErrorCodes(code: request.response?.statusCode ?? 0) == .unAuthorized,
            !isLoginRequest(request: request) {
            
            guard KeychainService.shared.load(with: .refreshToken) != "" else {
                return logout(completion: completion)
            }
                        
            requestAccessToken(completion: completion)
            
        } else if ErrorCodes(code: request.response?.statusCode ?? 0) == .serverError {
            
            serverErrorRetry(completion: completion)
            
        } else {
            retryRequestWithAnyError(request: request, completion: completion)
        }
    }
    
    private func retryRequestWithAnyError(request: Request, completion: (RetryResult) -> Void) {
        guard request.task?.response == nil,
            let url = request.request?.url?.absoluteString
        else {
            removeCachedUrlRequest(url: request.request?.url?.absoluteString)
            completion(.doNotRetry)
            return
        }
        
        guard let retryCount = retriedRequests[url] else {
            retriedRequests[url] = 1
            completion(.retryWithDelay(1))
            return
        }
        
        if retryCount <= 3 {
            retriedRequests[url] = retryCount + 1
            completion(.retryWithDelay(1))
        } else {
            removeCachedUrlRequest(url: url)
            completion(.doNotRetry)
        }
    }
    
    private func removeCachedUrlRequest(url: String?) {
        guard let url = url else {
            return
        }
        retriedRequests.removeValue(forKey: url)
    }
    
    private func serverErrorRetry(completion: (RetryResult) -> Void) {
        NotificationCenter.default.post(name: Notification.Name("Server 5xx Error"), object: nil)
        completion(.doNotRetry)
    }
    
    private func requestAccessToken(completion: @escaping (RetryResult) -> Void) {
        tokenRequested = true
        
        postRefreshToken(completionWithError: { [weak self] _ in
            self?.tokenRequested = false

            KeychainService.shared.deleteItem(for: .token)
            KeychainService.shared.deleteItem(for: .refreshToken)
            
            self?.logout(completion: completion)
            
        }, completionAccessToken: { [weak self] (accessToken) in
            self?.tokenRequested = false
           
            KeychainService.shared.save(string: accessToken, with: .token)
            
            completion(.retry)
        })
    }
    
    private func logout(completion: (RetryResult) -> Void) {
        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        completion(.doNotRetry)
    }
    
    private func isLoginRequest(request: Request) -> Bool {
        guard let url = request.request?.url, url.absoluteString.contains("login") else {
            return false
        }

        return true
    }
    
    private func isTeamsRequest(request: Request) -> Bool {
        guard let url = request.request?.url, url.absoluteString.contains("teams/namespace") else {
            return false
        }
        
        return true
    }
}

// MARK: - Create Environment base url

private extension RequestInterceptor {
    func createEnvironemtBaseURL() -> String {
        if let url = UserDefaults.standard.string(forKey: "base_url") {
            if url.contains("http://") {
                UserDefaults.standard.set(url.deletingPrefix("http://"), forKey: "admin_adress_info")
                return "http://api-" + url.replacingOccurrences(of: "http://", with: "")
            } else if url.contains("https://") {
                UserDefaults.standard.set(url.deletingPrefix("https://"), forKey: "admin_adress_info")
                return "https://api-" + url.replacingOccurrences(of: "https://", with: "")
            }
        }
        
        return "error"
    }
}
