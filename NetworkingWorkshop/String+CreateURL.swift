//
//  String+CreateURL.swift
//  NetworkingWorkshop
//
//  Created by Юлия Милованова on 15.04.2021.
//

import UIKit

extension String {
    func createUrlFromString() -> URL? {
        guard self.isEmpty == false else { return nil }
        
        var url: String
        self.contains("&")
            ? (url = self.replacingOccurrences(of: "amp;", with: ""))
            : (url = self)
        
        if let url = URL(string: url.trimmingCharacters(in: .whitespaces)) {
            return url
        } else {
            if let urlEscapedString = url.trimmingCharacters(in: .whitespaces)
                                            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let escapedURL = URL(string: urlEscapedString) {
                
                return escapedURL
            }
        }
        
        return nil
    }
}
