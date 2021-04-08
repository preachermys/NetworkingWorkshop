//
//  UserService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import UIKit

class UserService {
    static let shared = UserService()
    
    private let userManager = UserManager()
    
    private init() {}

    func uploadAvatar(image: UIImage, complated: @escaping (String) -> Void) {
        userManager.uploadAvatar(base64String: image.base64(), ext: "jpeg", completion: complated)
    }

    func updateUser(complated: @escaping () -> Void) {
        userManager.updateUser(completion: complated)
    }

    func changePassword(passwordOld: String,
                        passwordNew: String,
                        isCrypted: Bool,
                        complated: @escaping (String?) -> Void) {
        
        userManager.changePassword(
            oldPassword: passwordOld,
            newPassword: passwordNew,
            isCrypted: isCrypted,
            completion: complated
        )
    }
    
    func getSessionsList(completion: @escaping ([DeviceInfo]?) -> Void) {
        userManager.getSessionsList(completion: completion)
    }
    
    func removeSession(sessionId: String?, completion: @escaping (Bool) -> Void) {
        userManager.removeSession(sessionId: sessionId, completion: completion)
    }
    
    func removeAllSessions(successCompletion: @escaping () -> (), failureCompletion: @escaping () -> ()) {
        userManager.removeAllSessions(successCompletion: successCompletion, failureCompletion: failureCompletion)
    }
}

