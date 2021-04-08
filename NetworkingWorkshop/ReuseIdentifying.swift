//
//  ReuseIdentifying.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 05.04.2021.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
