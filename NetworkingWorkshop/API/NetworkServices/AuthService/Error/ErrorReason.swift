//
//  ErrorReason.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

enum ErrorReason {
    case none, userBlocked, invalidCredentials, tooManyDevices, tooManyRecoveryAttempts
    
    init(reason: String) {
        switch reason {
        case "invalid_credentials":
            self = .invalidCredentials
        case "user_is_blocked":
            self = .userBlocked
        case "Too many devices":
            self = .tooManyDevices
        case "Too many recovery attempts":
            self = .tooManyRecoveryAttempts
        default:
            self = .none
        }
    }
}
