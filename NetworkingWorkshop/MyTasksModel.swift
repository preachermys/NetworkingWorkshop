//
//  MyTasksModel.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation

enum MyTasksType {
    case overdue
    case inProgress
    case completed
    
    var stringValue: String {
        switch self {
        case .overdue: return "overdue"
        case .inProgress: return "in_progress"
        case .completed: return "completed"
        }
    }
    
    var sortValue: String {
        switch self {
        case .overdue: return "overdue_at"
        case .inProgress: return "created_at"
        case .completed: return "completed_at"
        }
    }
}

class MyTasksModel {
    var title: String
    var level: MyTasksType
    var count: Int

    init(title: String, level: MyTasksType, count: Int) {
        self.title = title
        self.level = level
        self.count = count
    }
}
