//
//  APIConfiguration.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

public protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
    
    func clearAuthBaseURL(baseURL: String) -> String
    func createEnvironemtBaseURL() -> String
}

public extension APIConfiguration {
    func clearAuthBaseURL(baseURL: String) -> String {
        if baseURL.contains("http://") {
            return "http://oauth-" + baseURL.replacingOccurrences(of: "http://", with: "")
        } else if baseURL.contains("https://") {
            return "https://oauth-" + baseURL.replacingOccurrences(of: "https://", with: "")
        }
        
        return ""
    }
    
    func createEnvironemtBaseURL() -> String {
        if let url = UserDefaults.standard.string(forKey: "base_url") {
            if url.contains("http://") {
                UserDefaults.standard.set(url.deletingPrefix("http://"), forKey: "admin_adress_info")
                return "http://api-" + url.replacingOccurrences(of: "http://", with: "")
            } else if url.contains("https://") {
                UserDefaults.standard.set(url.deletingPrefix("https://"), forKey: "admin_adress_info")
                return "https://api-" + url.replacingOccurrences(of: "https://", with: "")
            }
        }
        
        return ""
    }
    
    func asURLRequest() throws -> URLRequest {
        let url: URL = try createEnvironemtBaseURL().asURL()
        
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
    
    func asURL() -> String {
        if let url = try? asURLRequest().url?.absoluteString ?? "" {
            return url
        }
        
        return ""
    }
}

public enum RequestParams {
    case body(_: Parameters)
    case url(_: Parameters)
}

public enum ContentType: String {
    case json = "application/json"
}

public enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
