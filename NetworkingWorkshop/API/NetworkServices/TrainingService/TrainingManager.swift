//
//  TrainingManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

final class TrainingManager: CommonNetworkManager {
    
    // MARK: - Get training categories
    
    func getTrainingCategories(page: Int, perPage: Int, completion: @escaping ([TrainingCategoryEntity]) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = TrainingRouter.getTrainingCategories(userId: userId, page: page, perPage: perPage).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dataList = data["data"] as? [[String: Any]] {
                    
                    completion(dataList.map { CoreDataObjectFabric.createTrainingCategoryEntity(from: $0) })
                }
            case .failure:
                completion([])
            }
        }
    }
    
    func getCategory(by id: String, completion: @escaping (TrainingCategoryEntity) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = TrainingRouter.getCategory(userId: userId, categoryId: id).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dataList = data["data"] as? [[String: Any]],
                    let category = dataList.first {
                    
                    completion(CoreDataObjectFabric.createTrainingCategoryEntity(from: category))
                }

            case .failure: break
            }
        }
    }
    
    // MARK: - Get training by ids
    
    func getTrainings(by ids: [String], completion: @escaping ([TrainingEntity]) -> Void) {
        let request = TrainingRouter.getTrainingsBy(ids: ids).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dataList = data["data"] as? [[String: Any]] {
                    
                    completion(dataList.map { CoreDataObjectFabric.createTrainingEntity(from: $0) })
                }
            case .failure:
                completion([])
            }
        }
    }
}
