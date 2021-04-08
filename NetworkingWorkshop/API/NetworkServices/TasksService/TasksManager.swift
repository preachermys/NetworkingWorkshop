//
//  TasksManager.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 30.03.2021.
//

import Foundation

final class TasksManager: CommonNetworkManager {
    
    // MARK: - Get tasks count
    
    func getTasksCount(completion: @escaping (CardlessTasksEntity?) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = TasksRouter.getTasksCount(userId: userId).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                guard let data = data as? [String: Any] else {
                    completion(nil)
                    return
                }
                
                completion(CoreDataObjectFabric.createCardlessTasksObject(from: data))
            case .failure:
                completion(nil)
            }
        }
    }
    
    // MARK: - Get tasks by page
    
    func getTasks(by page: Int, _ type: MyTasksType, completion: @escaping ([TaskEntity]) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = TasksRouter.getTasksBy(page: page, userId: userId, type: type).asURL()
        
        session.request(request).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dict = data["data"] as? [[String: Any]] {
                    
                    completion(CoreDataObjectFabric.createTasksObjectsArray(from: dict))
                }
            case .failure:
                completion([])
            }
        }
    }
    
    // MARK: - Get tasks by ids
    
    func getTasks(by ids: [String], completion: @escaping (TaskEntity?) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = TasksRouter.getTasks(ids: ids, userId: userId)
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dict = data["data"] as? [[String: Any]],
                    let taskData = dict.first {
                    
                    completion(CoreDataObjectFabric.createTaskObject(from: taskData))
                }
            case .failure:
                completion(nil)
            }
        }
    }
    
    // MARK: - Post task result
    
    func postTaskResult(taskId: String, result: [String: Any], completion: @escaping (TaskEntity?) -> Void) {
        let request = TasksRouter.postTaskResult(taskId: taskId, result: result)
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dict = data["data"] as? [String: Any] {
                    
                    completion(CoreDataObjectFabric.createTaskObject(from: dict))
                }
            case .failure:
                completion(nil)
            }
            
        }
    }
    
    // MARK: - Get tags
    
    func getTags(page: Int, searchString: String, completion: @escaping ([String]) -> Void) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = TasksRouter.getTags(
            userId: userId,
            page: page,
            searchString: searchString
        ).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let response):
                if let dict = response as? [String: Any],
                    let dataArray = dict["data"] as? [String] {
                    
                    completion(dataArray)
                }
            case .failure:
                completion([])
            }
        }
    }
    
    // MARK: - Search tasks
    
    func searchTasks(
        page: Int,
        searchText: String,
        type: MyTasksType,
        completion: @escaping ([TaskEntity]) -> Void
    ) {
        guard let userId = UserModel.shared.userId else { return }
        
        let request = TasksRouter.searchTasks(
            userId: userId,
            page: page,
            searchText: searchText,
            type: type
        ).asURL()
        
        session.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let dict = data["data"] as? [[String: Any]] {
                    
                    completion(CoreDataObjectFabric.createTasksObjectsArray(from: dict))
                }
            case .failure:
                completion([])
            }
        }
    }
}
