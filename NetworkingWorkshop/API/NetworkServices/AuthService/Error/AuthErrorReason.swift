//
//  AuthErrorReason.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

enum AuthErrorReason {
    case none, userBlocked, invalidCredentials, tooManyDevices
    
    init(reason: String) {
        switch reason {
        case "invalid_credentials":
            self = .invalidCredentials
        case "user_is_blocked":
            self = .userBlocked
        case "Too many devices":
            self = .tooManyDevices
        default:
            self = .none
        }
    }
}
