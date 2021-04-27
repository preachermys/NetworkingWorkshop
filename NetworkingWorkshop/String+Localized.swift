//
//  String+Localized.swift
//  NetworkingWorkshop
//
//  Created by Юлия Милованова on 15.04.2021.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
