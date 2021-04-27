//
//  Array+Chunked.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 16.04.2021.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
