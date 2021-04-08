//
//  CommonNetworkManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire
//import Mocker

class CommonNetworkManager: SessionDelegate {
    
    let session = SessionRequestInterceptor.shared.session
    
    func clearAuthBaseURL(baseURL: String) -> String {
        if baseURL.contains("http://") {
            return "http://oauth-" + baseURL.replacingOccurrences(of: "http://", with: "")
        } else if baseURL.contains("https://") {
            return "https://oauth-" + baseURL.replacingOccurrences(of: "https://", with: "")
        }
        
        return ""
    }
}
