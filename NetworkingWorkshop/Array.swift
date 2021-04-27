//
//  Array.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 16.04.2021.
//

import Foundation

extension Array where Element: Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}
