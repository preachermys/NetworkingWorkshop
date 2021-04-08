//
//  AuthorizationManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

public protocol AuthorizationManagerProtocol {
    func getTeams(with login: String, codeScreen: Bool, completion: @escaping (Error?) -> Void)
    func login(with login: String, password: String, isCrypted: Bool, completion: @escaping (Error?) -> Void)
    func getAuthCode(completion: @escaping (Error?) -> Void)
    func getToken(code: String, completion: @escaping (Error?) -> Void)
//    func postRecovery(email: String, completion: @escaping (Error?, String?) -> Void)
//    func postCode(login: String, code: String, phone: Bool, completion: @escaping (Error?, String?) -> Void)
    func generateCode(code: String, completion: @escaping (String) -> Void)
    func postSessionCode(enteredCode: String, id: String, completion: @escaping (Result<Void, SessionError>) -> Void)
    
    func postRefreshToken(
        completionWithError: @escaping (Error?) -> Void,
        completionAccessToken: @escaping (String) -> Void
    )
    
//    func postRecoveryCode(
//        email: String,
//        code: String,
//        newPassword: String,
//        isCrypted: Bool,
//        completion: @escaping (Error?, String?) -> Void
//    )
}

final class AuthorizationManager: CommonNetworkManager, AuthorizationManagerProtocol {
    private enum Constants {
        static let userNameKey = "username"
        static let urlKey = "url"
        static let errorsKey = "errors"
        static let recoveryAttempts = "recovery_attempts"
    }
    
    private struct Errors: Codable {
        let errors: DevicesError
        
        struct DevicesError: Codable {
            let device: String
            let deviceCount: Int
        }
    }
    
    typealias TeamsCompletion = (Error?) -> Void
    typealias LoginCompletion = (Error?) -> Void
    typealias AccessTokenErrorCompletion = (Error?) -> Void
    typealias AccessTokenCompletion = (String) -> Void
    typealias PostRecoveryCompletion = (Error?, String?) -> Void
    
    // MARK: - Get teams
    
    func getTeams(with login: String, codeScreen: Bool, completion: @escaping TeamsCompletion) {
        session.request(AuthRouter.getTeams(userName: login, codeScreen: codeScreen).asURL()).validate().responseDecodable(of: [TeamsModel].self) { response in
            self.processTeams(with: response, completion: completion)
        }
    }
    
    private func processTeams(with response: (DataResponse<[TeamsModel], AFError>),
                              completion: @escaping TeamsCompletion) {
        switch response.result {
        case .success(let teams):
            if let domain = teams.first?.domain {
                NetworkConstants.baseAuthUrl = domain + "/"
            }
            
            NetworkConstants.companyNamespace = teams.first?.namespace
            
            completion(nil)
        case .failure(let error):
            completion(error)
        }
    }
    
    // MARK: - Login
    
    func login(with login: String, password: String, isCrypted: Bool, completion: @escaping LoginCompletion) {
        UserDefaults.standard.set(NetworkConstants.baseAuthUrl, forKey: "base_url")
        UserDefaults.standard.synchronize()
        session.request(AuthRouter.login(username: login, password: password, isCrypted: isCrypted)).validate().responseJSON { response in
            self.processLogin(with: response, completion: completion)
        }
    }
    
    private func processLogin(with response: (DataResponse<Any, AFError>),
                              completion: @escaping LoginCompletion) {
        switch response.result {
        case .success(let data):
            
            if let fields = response.response?.allHeaderFields as? [String: String],
                let url = response.response?.url,
                let baseUrl = URL(string: clearAuthBaseURL(baseURL: NetworkConstants.baseAuthUrl) + "oauth/authorize") {
                
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
                HTTPCookieStorage.shared.setCookies(cookies,
                                                    for: baseUrl,
                                                    mainDocumentURL: nil)
                
                if cookies.isEmpty || !(200...299).contains(response.response?.statusCode ?? 0) {
                    guard let responseJSON = data as? [String: Any],
                        let errors = responseJSON[Constants.errorsKey] as? [String: String] else {
                            completion(CookiesError.noCookies)
                            return
                    }
                    
                    if let error = errors[Constants.userNameKey] {
                        let reason = ErrorReason(reason: error)
                        let error = AuthError(code: response.response?.statusCode ?? 0,
                                              reason: reason)
                        completion(error)
                        return
                    }
                    
                    guard errors[Constants.urlKey] != nil else {
                        completion(CookiesError.noCookies)
                        return
                    }
                    
                    completion(CookiesError.noCookies)
                    return
                }

            }
            
            if (data as? [String: Any]) != nil {
                LogoutService.shared.isSignedIn = true
                
                self.getAuthCode(completion: completion)
            }
            
        case .failure(let error):
            completion(error)
        }
    }

    // MARK: - Get Auth Code request
    
    func getAuthCode(completion: @escaping LoginCompletion) {
        let redirector = Redirector()
        
        redirector.tokenHandler = { [weak self] code in
            self?.getToken(code: code, completion: completion)
        }
        
        session.request(AuthRouter.getAuthCode).validate().response { _ in }.redirect(using: redirector)
    }
    
    // MARK: - Get token
    
    func getToken(code: String, completion: @escaping LoginCompletion) {
        session.request(AuthRouter.getToken(code: code)).validate().responseJSON { response in
            self.processToken(with: response, code: code, completion: completion)
        }
    }
    
    private func processToken(
        with response: (DataResponse<Any, AFError>),
        code: String,
        completion: @escaping LoginCompletion
    ) {
        switch response.result {
        case .success(let data):
            
            if let responseJSON = data as? [String: Any],
                let codeError = responseJSON["code"] as? Int, codeError == 400,
                let errors = responseJSON[Constants.errorsKey] as? [String: Any],
                let device = errors["device"] as? String,
                let deviceCount = errors["device_count"] as? Int {
                
                completion(AuthError(code: codeError,
                                     reason: ErrorReason(reason: device),
                                     maxDeviceViolation: deviceCount))
            }
            
            if let responseJSON = data as? [String: Any],
                let deviceId = responseJSON["device_id"] as? String,
                let refreshToken = responseJSON["refresh_token"] as? String {
                
                if let token = responseJSON["access_token"] as? String {
                    KeychainService.shared.save(string: token, with: .token)
                }
                
                UserModel.shared.deviceId = deviceId
                KeychainService.shared.save(string: refreshToken, with: .refreshToken)
                KeychainService.shared.save(string: deviceId, with: .deviceId)
            
                completion(nil)
            }
            
        case .failure:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let errorType = try? decoder.decode(Errors.self, from: response.data ?? Data()) else {
                return completion(nil)
            }
            
            completion(AuthError(code: response.response?.statusCode ?? 0,
                                 reason: ErrorReason(reason: errorType.errors.device),
                                 maxDeviceViolation: errorType.errors.deviceCount,
                                 authCode: code))
        }
    }
    
    // MARK: - Post refresh token
    
    func postRefreshToken(completionWithError: @escaping AccessTokenErrorCompletion,
                          completionAccessToken: @escaping AccessTokenCompletion) {
        let request = AuthRouter.postRefreshToken
        
        session.request(request).validate().responseData { response in
            
            switch response.result {
            case .success(let data):
                if let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                    guard let token = dictionary["access_token"] as? String,
                        let refreshtoken = dictionary["refresh_token"] as? String else {
                            guard let error = dictionary["errors"]?["authentication"] as? String,
                                error == "user_is_blocked" else {
                                    completionWithError(nil)
                                    LogoutService.shared.logout()
                                    return
                            }
                            
                            MainThread.performOn(async: true, execute: {
//                                AlertService.showBlockedUserAlert(completion: {
                                    LogoutService.shared.logout()
//                                })
                            })
                            
                            return
                    }
                    
                    KeychainService.shared.save(string: token, with: .token)
                    KeychainService.shared.save(string: refreshtoken, with: .refreshToken)

                    completionAccessToken(token)
                } else {
                    if let code = response.response?.statusCode,
                        ErrorCodes(code: code) == .unAuthorized {
                        
                        completionWithError(AuthError(code: code, reason: .userBlocked))
                    } else {
                        completionWithError(CookiesError.noCookies)
                    }
                }
            case .failure(let error):
                completionWithError(error)
            }
        }
    }
    
    // MARK: - Recovery password
    
//    func postRecovery(email: String, completion: @escaping PostRecoveryCompletion) {
//        let request = AuthRouter.postRecovery(email: email)
//
//        session.request(request).validate().response { response in
//
//            switch response.result {
//            case .success(let data):
//                if !(200...299).contains(response.response?.statusCode ?? 0), let data = data {
//                    let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
//                    guard let responseJSON = dictionary else {
//                        completion(CookiesError.noCookies, nil)
//                        return
//                    }
//
//                    guard let errors = responseJSON[Constants.errorsKey] as? [String: Any] else {
//                        completion(CookiesError.noCookies, nil)
//                        return
//                    }
//
//                    if let error = errors[Constants.userNameKey] as? String {
//                        let reason = ErrorReason(reason: error)
//                        let error = AuthError(code: response.response?.statusCode ?? 0,
//                                              reason: reason)
//                        completion(error, nil)
//                        return
//                    } else if let recoveryAttempts = errors[Constants.recoveryAttempts] as? String {
//                        let reason = ErrorReason(reason: recoveryAttempts)
//                        let error = AuthError(code: response.response?.statusCode ?? 0, reason: reason)
//                        completion(error, nil)
//                        return
//                    }
//
//                    completion(CookiesError.noCookies, nil)
//                }
//
//                completion(nil, "")
//            case .failure(let error):
//                completion(error, nil)
//            }
//        }
//    }
//
//    func postRecoveryCode(email: String,
//                          code: String,
//                          newPassword: String,
//                          isCrypted: Bool,
//                          completion: @escaping (Error?, String?) -> Void) {
//
//        let request = AuthRouter.postRecoveryCode(email: email, code: code, newPassword: newPassword, isCryped: isCrypted)
//
//        session.request(request).validate().response { response in
//
//            switch response.result {
//            case .success(let data):
//                if response.response?.statusCode == 400, let data = data {
//
//                    let dictionary = try? JSONDecoder().decode(PasswordRecoveryError.self, from: data)
//
//                    switch dictionary?.errors.code {
//                    case "password_short":
//                        dictionary?.errors.requiredLength == 6
//                            ? completion(nil, "user_required_length".localized)
//                            : completion(nil, "admin_required_length".localized)
//                    default:
//                        completion(nil, "400")
//                    }
//                } else {
//                    completion(nil, "")
//                }
//            case .failure(let error):
//                completion(error, nil)
//            }
//        }
//    }
//
//    func postCode(login: String, code: String, phone: Bool, completion: @escaping (Error?, String?) -> Void) {
//        let request = AuthRouter.postCode(login: login, code: code, phone: phone)
//
//        session.request(request).validate().response { response in
//
//            switch response.result {
//            case .success(let data):
//
//                if response.response?.statusCode == 400, let data = data {
//                    let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
//                    if let error = dictionary?[Constants.errorsKey] as? [String: String],
//                        let showError = error["code"] {
//
//                        completion(nil, showError)
//                    }
//                } else {
//                    completion(nil, nil)
//                }
//
//            case .failure(let error):
//                completion(error, nil)
//            }
//        }
//    }
    
    // MARK: - Post lead generation
    
    func postLeadgen(fullname: String, phone: String, organization: String, email: String) {
        let request = AuthRouter.postLeadgen(fullname: fullname,
                                             phone: phone,
                                             organization: organization,
                                             email: email)
        
        session.request(request).validate().resume()
    }
    
    func generateCode(code: String, completion: @escaping (String) -> Void) {
        let request = AuthRouter.generateCode(code: code)
        
        session.request(request).validate().response { response in
            switch response.result {
            case .success(let data):
                if let data = data,
                   let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject],
                   let codeJSON = responseJSON["code"] as? [String: Any],
                   let id = codeJSON["id"] as? String {
                    
                    completion(id)
                }
            case .failure:
                completion("")
            }
        }
    }
    
    func postSessionCode(enteredCode: String, id: String, completion: @escaping (Result<Void, SessionError>) -> Void) {
        let request = AuthRouter.postSessionCode(enteredCode: enteredCode, id: id)
        
        session.request(request).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                if let responseJSON = data as? [String: Any],
                   let token = responseJSON["access_token"] as? String {
                    RequestInterceptor.shared.tempToken = token
                    
                    completion(.success(()))
                }
            case .failure:
                guard let errorType = try? JSONDecoder().decode(SessionErrors.self, from: response.data ?? Data()) else {
                    return
                }
                
                completion(.failure(SessionError(error: errorType.errors.error)))
            }

        }
    }
}

// MARK: - Session Error models

extension AuthorizationManager {
    private struct SessionErrors: Codable {
        let errors: SessionError
        
        struct SessionError: Codable {
            let error: String
        }
    }
}

public enum SessionError: Error {
    case invalidCode
    case unpredictableError
    
    init(error: String) {
        switch error {
        case "invalid_code", "code_not_found": self = .invalidCode
        default: self = .unpredictableError
        }
    }
}

