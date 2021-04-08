//
//  ErrorCodes.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

enum ErrorCodes {
    case unAuthorized, userBlocked, success, serverError
    
    init(code: Int) {
        switch code {
        case 400:
            self = .userBlocked
        case 401:
            self = .unAuthorized
        case 500...599:
            self = .serverError
        default:
            self = .success
        }
    }
}
