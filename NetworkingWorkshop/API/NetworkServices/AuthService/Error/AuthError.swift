//
//  AuthError.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

struct AuthError: Error {
    var code: Int
    var reason: ErrorReason
    var maxDeviceViolation: Int?
    var authCode: String?
}
