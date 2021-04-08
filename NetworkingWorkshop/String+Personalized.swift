//
//  String+Personalized.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 05.04.2021.
//

import Foundation

extension String {
    var personalize: String {
        return replacingOccurrences(of: "%username%", with: UserModel.shared.firstname)
    }
}
