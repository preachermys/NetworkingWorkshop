//
//  Redirector.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

final class Redirector: RedirectHandler {
    
    typealias TokenHandler = (String) -> Void
    
    var tokenHandler: TokenHandler?
    
    func task(_ task: URLSessionTask,
              willBeRedirectedTo request: URLRequest,
              for response: HTTPURLResponse,
              completion: @escaping (URLRequest?) -> Void) {
        
        let redirectUrl = request.url?.absoluteString
        guard var code = redirectUrl?.components(separatedBy: "code=")[1] else { return }
        code = String(code.getSubstring(to: "&").reversed())
    
        tokenHandler?(code)
    }
}

