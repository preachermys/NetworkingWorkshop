//
//  SessionService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

final class SessionRequestInterceptor {
    
    let session = Session(interceptor: RequestInterceptor.shared)
    
    private init() { }
    static let shared = SessionRequestInterceptor()
}
