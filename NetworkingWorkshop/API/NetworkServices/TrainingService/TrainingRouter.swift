//
//  TrainingRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Alamofire

enum TrainingRouter: APIConfiguration {
    
    case getTrainingCategories(userId: String, page: Int, perPage: Int)
    case getTrainingsBy(ids: [String])
    case getCategory(userId: String, categoryId: String)
    
    var method: HTTPMethod {
        switch self {
        case .getTrainingCategories, .getTrainingsBy, .getCategory:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getTrainingCategories(let userId, _, _):
            return "v1/users/\(userId)/categories/trainings"
        case .getTrainingsBy:
            return "v1/trainings"
        case .getCategory(let userId, _):
            return "v1/users/\(userId)/categories/trainings"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getTrainingCategories(_, let page, let perPage):
            return .url([
                "offset": page * perPage,
                "per_page": perPage
            ])
        case .getTrainingsBy(let ids):
            return .url([
                "filters": ("{\"id\":[\"" + ids.joined(separator: "\", \"") + "\"]}").utf8
            ])
        case .getCategory(_, let categoryId):
            return .url([
                "filters": ("{\"categoryIds\":[\"" + categoryId + "\"]}").utf8
            ])
        }
    }
    
}
