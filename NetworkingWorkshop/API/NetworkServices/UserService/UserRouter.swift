//
//  UserRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

public enum UserRouter: APIConfiguration {

    case getCurrentUser(userId: String)
    case uploadAvatar(base64String: String, ext: String)
    case updateUser
    case getRoles
    
    case changePassword(oldPassword: String, newPassword: String, isCrypted: Bool)
    
    case getSessionsList(userId: String)
    case removeSession(sessionId: String)
    case removeAllSessions(userId: String)
    
    case postPushToken(pushToken: String)
    case removePushToken(pushToken: String)

    public var method: HTTPMethod {
        switch self {
        case .getCurrentUser,
             .getSessionsList,
             .getRoles:
            return .get
        case .uploadAvatar,
             .postPushToken:
            return .post
        case .updateUser,
             .removeSession,
             .removeAllSessions:
            return .patch
        case .changePassword:
            return .put
        case .removePushToken:
            return .delete
        }
    }

    public var path: String {
        switch self {
        case .getCurrentUser(let userId):
            return "v1/users/\(userId)"
        case .uploadAvatar:
            return "v1/resources/upload"
        case .updateUser:
            return "v1/user"
        case .getRoles:
            return "v1/roles"
        case .changePassword:
            return "v1/user/password"
        case .getSessionsList(let userId):
            return "v1/users/\(userId)/sessions/list"
        case .removeSession(let sessionId):
            return "v1/users/device/\(sessionId)/sessions/clear"
        case .removeAllSessions(let userId):
            return "v1/users/\(userId)/devices/clear"
        case .removePushToken(let pushToken):
            return "v1/user/devices/\(pushToken)"
        case .postPushToken:
            return "v1/user/devices"
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .getCurrentUser:
            return .body([:])
        case .uploadAvatar(let base64String, let ext):
            return .body([
                "body": base64String,
                "extension": ext
            ])
        case .updateUser:
            return .body([
                "firstname": UserModel.shared.firstname,
                "lastname": UserModel.shared.lastname,
                "middlename": UserModel.shared.middlename,
                "image": UserModel.shared.image
            ])
        case .changePassword(let oldPassword, let newPassword, let isCrypted):
            let body = isCrypted
                ? ["password_old": oldPassword,
                   "password_new": newPassword,
                   "is_crypted": isCrypted]
                : ["password_old": oldPassword,
                   "password_new": newPassword]
            
            return .body(body)
        case .postPushToken(let pushToken):
            return .body([
                "push_token": pushToken,
                "language": Locale.current.languageCode ?? "en"
            ])
        case .getSessionsList, .removeSession, .removePushToken, .getRoles, .removeAllSessions:
            return .body([:])
        }
    }
}
