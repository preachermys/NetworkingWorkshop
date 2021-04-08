//
//  CookiesError.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

final class CookiesError: Error {
    var message: String
    static var noCookies: CookiesError {
        return CookiesError(message: "no cookies")
    }
    
    init(message: String) {
        self.message = message
    }
}
