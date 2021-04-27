//
//  Array+Safe.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 16.04.2021.
//

extension Array {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
