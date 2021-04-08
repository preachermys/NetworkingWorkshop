//
//  AuthRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire
//import netfox

public enum AuthRouter: APIConfiguration {

    case getTeams(userName: String, codeScreen: Bool)
    case login(username: String, password: String, isCrypted: Bool)
    case getAuthCode
    case getToken(code: String)
    
    case postRefreshToken
    
    case postRecovery(email: String)
    case postRecoveryCode(email: String, code: String, newPassword: String, isCryped: Bool)
    case postCode(login: String, code: String, phone: Bool)
    case generateCode(code: String)
    case postSessionCode(enteredCode: String, id: String)
    
    case postLeadgen(fullname: String, phone: String, organization: String, email: String)
        
    public var method: HTTPMethod {
        switch self {
        case .getTeams,
             .getAuthCode:
            return .get
        case .login,
             .getToken,
             .postRecovery,
             .postRecoveryCode,
             .postCode,
             .postLeadgen,
             .postRefreshToken,
             .generateCode,
             .postSessionCode:
            return .post
        }
    }

    public var path: String {
        switch self {
        case .getTeams(let username, let codeScreen):
            return codeScreen
                ? "teams/namespace/\(username)"
                : "users/\(username)/teams"
        case .login:
            return "login"
        case .getAuthCode:
            return "oauth/authorize"
        case .getToken:
            return "oauth/token"
        case .postRecovery:
            return "recover"
        case .postRecoveryCode:
            return "recover"
        case .postCode:
            return "recover/validate"
        case .postLeadgen:
            return "lead/generation/mail"
        case .postRefreshToken:
            return "oauth/token"
        case .generateCode:
            return "code/device/generate"
        case .postSessionCode:
            return "code/device/confirm"
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .getTeams:
            return .body([:])
        case .login(let username, let password, let isCrypted):
            var body: [String: Any]
            body = [
                "password": password,
                "device_info": ["type": "mobile",
                                "name": "iPhone 11",
                                "os": "iOS 14.2",
                                "app_version": "2.7.0"]
            ]
            
            if let namespace = NetworkConstants.companyNamespace {
                body["namespace"] = namespace
                body["username"] = username
            } else {
                body["username"] = username.lowercased()
            }
            
            if isCrypted {
                body["is_crypted"] = isCrypted
            }
            
            return .body(body)
        case .getAuthCode:
            if let namespace = NetworkConstants.companyNamespace {
                return .url(["response_type": "code",
                              "redirect_uri": NetworkConstants.redirectURL,
                              "client_id": NetworkConstants.clientId,
                              "namespace": namespace])
            } else {
                return .url(["response_type": "code",
                              "redirect_uri": NetworkConstants.redirectURL,
                              "client_id": NetworkConstants.clientId])
            }
        case .getToken(let code):
            return .body(["grant_type": "authorization_code",
                    "code": code,
                    "client_id": NetworkConstants.clientId,
                    "redirect_uri": NetworkConstants.redirectURL,
                    "identity_id": "iPhone 11",
                    "device_info": ["type": "mobile",
                                    "name": "iPhone 11",
                                    "os": "iOS 14.4",
                                    "app_version": "2.7.0"]])
        case .postRecovery(let email):
            return .body([
                "email": email
            ])
        case .postRecoveryCode(let email, let code, let newPassword, let isCrypted):
            let body = isCrypted
                ? ["email": email,
                   "code": code,
                   "password": newPassword,
                   "is_crypted": isCrypted]
                : ["email": email,
                   "code": code,
                   "password": newPassword]
            return .body(body)
        case .postCode(let login, let code, let phone):
            if phone {
                return .body([
                    "phone": login,
                    "code": code
                ])
            } else {
                return .body([
                    "email": login,
                    "code": code
                ])
            }
        case .postLeadgen(let fullname, let phone, let organization, let email):
            return .body([
                "fullname": fullname,
                "phone": phone,
                "organization": organization,
                "email": email
            ])
        case .postRefreshToken:
            return .body([
                "grant_type": "refresh_token",
                "refresh_token": KeychainService.shared.load(with: .refreshToken),
                "client_id": NetworkConstants.clientId
            ])
        case .generateCode(let code):
            return .body([
                "code": code
            ])
        case .postSessionCode(let enteredCode, let id):
            return .body([
                "id": id,
                "code": enteredCode,
                "client_id": NetworkConstants.clientId
            ])
        }
    }

    public func asURLRequest() throws -> URLRequest {
        let url: URL
        
        switch self {
        case .getTeams(_, let codeScreen):
            url = codeScreen
                ? try NetworkConstants.codeScreenTeamsURL.asURL()
                : try NetworkConstants.teamsURL.asURL()
        case .login, .getAuthCode, .getToken, .postRecovery,
             .postRecoveryCode, .postCode, .postRefreshToken,
             .generateCode, .postSessionCode:
            url = try clearAuthBaseURL(baseURL: NetworkConstants.baseAuthUrl).asURL()
        case .postLeadgen:
            #if DEBUG
                url = try "https://devteams.skillcup.ru/v1/".asURL()
            #else
                url = try NetworkConstants.teamsURL.asURL()
            #endif
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue,
                            forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        switch parameters {
            
        case .body(let params):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            
        case .url(let params):
            let queryParams = params.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }
        
//        if case .getAuthCode = self {
//            NFX.sharedInstance().ignoreURL(urlRequest.url?.absoluteString ?? "")
//        }
                
        return urlRequest
    }
}
