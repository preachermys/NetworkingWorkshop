//
//  UniversallinkRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

enum UniversallinkRouter: APIConfiguration {
    
    case postUniversalLink(url: String)
    case postUniversalLinkAutoLogin(url: String, baseURL: String)
    
    var method: HTTPMethod {
        switch self {
        case .postUniversalLink, .postUniversalLinkAutoLogin:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .postUniversalLink:
            return "v1/share/resolve"
        case .postUniversalLinkAutoLogin:
            return "v1/share/token/resolve"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .postUniversalLink(let url):
            return .body([
                "url": url
            ])
        case .postUniversalLinkAutoLogin(let url, _):
            return .body([
                "url": url
            ])
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url: URL
        
        switch self {
        case .postUniversalLink:
            url = try createEnvironemtBaseURL().asURL()
        case .postUniversalLinkAutoLogin(_, let baseURL):
            url = try ("https://" + baseURL).asURL()
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue,
                            forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        switch parameters {
            
        case .body(let params):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            
        case .url(let params):
            let queryParams = params.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }
                
        return urlRequest
    }

}
