//
//  UserManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

public protocol UserManagerProtocol {
    func getCurrentUser(completion: @escaping () -> (), failureCompletion: EmptyClosure?)
    func uploadAvatar(base64String: String, ext: String, completion: @escaping (String) -> Void)
    func updateUser(completion: @escaping () -> ())
    func getSessionsList(completion: @escaping ([DeviceInfo]?) -> Void)
//    func getRoles(successCompletion: @escaping ([Role]) -> Void, failureCompletion: @escaping () -> ())
    func removeSession(sessionId: String?, completion: @escaping (Bool) -> Void)
    func postPushToken(pushToken: String, completion: @escaping (PushTokenError) -> Void)
    func removePushToken(pushToken: String, completion: @escaping () -> ())
    
    func changePassword(
        oldPassword: String,
        newPassword: String,
        isCrypted: Bool,
        completion: @escaping (String?) -> Void
    )
}

final class UserManager: CommonNetworkManager, UserManagerProtocol {
    private struct Errors: Codable {
        let errors: UserManagerErrorType
        
        struct UserManagerErrorType: Codable {
            let password: String
        }
    }

    // MARK: - Get current user
    
    func getCurrentUser(completion: @escaping () -> (), failureCompletion: EmptyClosure? = nil) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = UserRouter.getCurrentUser(userId: userId).asURL()
        
        session.request(request).validate().responseJSON { [weak self] response in
            self?.processCurrentUser(response: response, completion: completion, failureCompletion: failureCompletion)
        }
    }
    
    private func processCurrentUser(response: DataResponse<Any, AFError>,
                                    completion: () -> (),
                                    failureCompletion: EmptyClosure?) {

        switch response.result {
        case .success(let user):
            if let user = user as? [String: Any],
                let dataList = user["data"] as? [String: Any] {
                
                updateCurrentUser(dataList: dataList)
//                NotificationService.shared.sendOnesignalSettings()
                completion()
            }
        case .failure:
            failureCompletion?()
        }
    }
    
    // MARK: - Upload new avatar
    
    func uploadAvatar(base64String: String, ext: String, completion: @escaping (String) -> Void) {
        let request = UserRouter.uploadAvatar(base64String: base64String, ext: ext)
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let response):
                if let response = response as? [String: Any],
                    let link = response["link"] as? String {
                    
                    UserModel.shared.image = link
                }
                
                completion(UserModel.shared.image)
            case .failure:
                completion("")
            }
        }
    }
    
    // MARK: - Update user
    
    func updateUser(completion: @escaping () -> ()) {
        let request = UserRouter.updateUser
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let response):
                if let response = response as? [String: Any],
                    let dataList = response["data"] as? [String: Any] {
                    
                    self.updateCurrentUser(dataList: dataList)
                    completion()
                }
            case .failure:
                completion()
            }
        }
    }
    
    // MARK: - Get sessions list
    
    func getSessionsList(completion: @escaping ([DeviceInfo]?) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = UserRouter.getSessionsList(userId: userId).asURL()
        
        session.request(request).validate().responseDecodable(of: SessionsListModel.self) { response in
            
            switch response.result {
            case .success(let response):
                completion(response.data)
            case .failure:
                completion([])
            }
            
        }
    }
    
    // MARK: - Remove session
    
    func removeSession(sessionId: String?, completion: @escaping (Bool) -> Void) {
        guard let sessionId = sessionId else { return }
        
        let request = UserRouter.removeSession(sessionId: sessionId)
        
        session.request(request).validate().response { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func removeAllSessions(successCompletion: @escaping () -> (), failureCompletion: @escaping () -> ()) {
        guard let userId = UserModel.shared.userId else { return }
        
        session.request(UserRouter.removeAllSessions(userId: userId)).validate().response { response in
            switch response.result {
            case .success: successCompletion()
            case .failure: failureCompletion()
            }
        }
    }
    
    // MARK: - Change password
    
    func changePassword(oldPassword: String,
                        newPassword: String,
                        isCrypted: Bool,
                        completion: @escaping (String?) -> Void) {
        
        let request = UserRouter.changePassword(
            oldPassword: oldPassword, newPassword: newPassword, isCrypted: isCrypted
        )
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                
                if let data = data as? [String: Any] {
                    if let dataList = data["data"] as? [String: Any] {
                        
                        self.updateCurrentUser(dataList: dataList)
                        completion(nil)
                    } else if let errors = data["errors"] as? [String: Any],
                        let error = errors["password"] as? String {
                        completion(error)
                    }
                }

            case .failure(let error):
                guard let errorType = try? JSONDecoder().decode(Errors.self, from: response.data ?? Data()) else {
                    return completion(error.localizedDescription)
                }
                
                completion(errorType.errors.password)
            }
        }
    }
    
    // MARK: - Post push token
    
    func postPushToken(pushToken: String, completion: @escaping (PushTokenError) -> Void) {
        let request = UserRouter.postPushToken(pushToken: pushToken)
        
        session.request(request).validate().responseData { response in
            
            switch response.result {
            case .success(let data):
                let dictonary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                if let data = dictonary?["data"] as? [String: Any],
                    let id = data["id"] as? String {
                    
                    UserModel.shared.pushToken = id
                    completion(.success)
                }
            case .failure(let error):
                completion(.error)
            }
        }.resume()
    }
    
    // MARK: - Remove push token
    
    func removePushToken(pushToken: String, completion: @escaping () -> ()) {
        let request = UserRouter.removePushToken(pushToken: pushToken)
        
        session.request(request).validate().response { _ in completion() }
    }
    
    // MARK: - Get roles
    
//    func getRoles(successCompletion: @escaping ([Role]) -> Void, failureCompletion: @escaping () -> ()) {
////        let request = UserRouter.getRoles.asURL()
////
////        session.request(request).validate().responseDecodable(of: RolesData.self) { response in
////
////            switch response.result {
////            case .success(let data):
////                successCompletion(data.data)
////            case .failure:
////                failureCompletion()
////            }
////        }
//    }
}

private extension UserManager {
    func updateCurrentUser(dataList: [String: Any]) {
        UserModel.shared.email = (dataList["email"] as? String) ?? ""
        UserModel.shared.hiredAt = (dataList["hired_at"] as? String) ?? ""
        UserModel.shared.firstname = (dataList["firstname"] as? String) ?? ""
        UserModel.shared.lastname = (dataList["lastname"] as? String) ?? ""
        UserModel.shared.department = (dataList["department"] as? String) ?? ""
        UserModel.shared.roles = (dataList["roles"] as? [String]) ?? []
        UserModel.shared.username = (dataList["username"] as? String) ?? ""
        UserModel.shared.position = (dataList["position"] as? String) ?? ""
        UserModel.shared.middlename = (dataList["middlename"] as? String) ?? ""
        UserModel.shared.location = (dataList["location"] as? String) ?? ""
        UserModel.shared.phone = (dataList["phone"] as? String) ?? ""
        UserModel.shared.isAdmin = (dataList["is_admin"] as? Int) == 1
        UserModel.shared.groups = (dataList["groups"] as? [String]) ?? []
        
        if let imageDictionary = dataList["image"] as? [String: Any] {
            let images = MediaFormatService.getAvailableImages(from: imageDictionary)
            UserModel.shared.image = MediaFormatService.getFormattedImage(from: images,
                                                                          basedOn: 100)?.absoluteString ?? ""
        }
    }

}
