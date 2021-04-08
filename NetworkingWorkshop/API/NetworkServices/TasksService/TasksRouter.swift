//
//  TasksRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

enum TasksRouter: APIConfiguration {

    case getTasksCount(userId: String)
    case getTasksBy(page: Int, userId: String, type: MyTasksType)
    case getTasks(ids: [String], userId: String)
    case searchTasks(userId: String, page: Int, searchText: String, type: MyTasksType)
    
    case postTaskResult(taskId: String, result: [String: Any])
    
    case getTags(userId: String, page: Int, searchString: String)
    
    var method: HTTPMethod {
        switch self {
        case .getTasksBy, .getTasks, .getTasksCount, .getTags, .searchTasks:
            return .get
        case .postTaskResult:
            return .patch
        }
    }

    var path: String {
        switch self {
        case .getTasksCount(let userId):
            return "v1/users/cardless/\(userId)/tasks"
        case .getTasksBy(_, let userId, _):
            return "v1/users/\(userId)/tasks"
        case .getTasks(_, let userId):
            return "v1/users/\(userId)/tasks"
        case .postTaskResult(let taskId, _):
            return "v1/tasks/\(taskId)"
        case .getTags(let userId, _, _):
            return "v1/users/\(userId)/task/tags"
        case .searchTasks(let userId, _, _, _):
            return "v1/users/\(userId)/tasks"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getTasksCount:
            return .body([:])
        case .getTasksBy(let page, _, let type):
            return .url([
                "offset": page * 10,
                "per_page": 10,
                "filters": ("{\"status\":\"\(type.stringValue)\"}").utf8,
                "sort": ("{\"\(type.sortValue)\":\"desc\"}").utf8
            ])
        case .getTasks(let ids, _):
            return .url([
                "filters": ("{\"id\":[\"" + ids.joined(separator: "\", \"") + "\"]}").utf8
            ])
        case .postTaskResult(_, let result):
            return .body(result)
        case .getTags(_, let page, let searchString):
            return .url([
                "offset": "\(page * 20)",
                "per_page": 20,
                "search": searchString
            ])
        case .searchTasks(_, let page, let searchText, let type):
            return .url([
                "offset": "\(page * 20)",
                "per_page": 20,
                "search": searchText,
                "filters": ("{\"status\":\"\(type.stringValue)\"}").utf8,
            ])
        }
    }
}
