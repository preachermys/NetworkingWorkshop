//
//  String+Plural.swift
//  NetworkingWorkshop
//
//  Created by Юлия Милованова on 15.04.2021.
//

import Foundation

extension String {
    func makePluralString(with count: Int) -> String {
        let resultString = String.localizedStringWithFormat(self.localized, count)
        return resultString
    }
}
