//
//  MainThread.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation

enum MainThread {
    static func performOn(async: Bool = false, execute: @escaping () -> ()) {
        if Thread.isMainThread {
            execute()
        } else {
            let queue = DispatchQueue.main
            async ? queue.async { execute() } : queue.sync { execute() }
        }
    }
}

