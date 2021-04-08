//
//  TasksService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData
import UIKit

class TasksService {
    static let shared = TasksService()

    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    private let tasksManager = TasksManager()
    
    private init() {
        privateMOC.persistentStoreCoordinator = CoreDataStack.shared.createPersistentStoreCoordinator()
        privateMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func getTasksByPage(page: Int, type: MyTasksType, completion: @escaping ([TaskEntity]) -> Void) {
        tasksManager.getTasks(by: page, type) { [weak self] tasks in
            self?.loadTasksByIds(ids: tasks.compactMap({ $0.id }), type: type) { tasks in
                let cardsIds = tasks.compactMap({ $0.cardId })
                let trainingsIds = tasks.compactMap({ $0.trainingId })
                
                let group = DispatchGroup()
                group.enter()
                FeedService.shared.getCards(page: page, cardsIds: cardsIds, complated: { cards in
                    cards.forEach({ card in
                        tasks.forEach({ task in
                            if task.cardId == card.id {
                                task.card = card
                            }
                        })
                    })
                    group.leave()
                })
                
                group.enter()
                TrainingService.shared.getTrainingsByIds(categoryId: "", ids: trainingsIds) { (trainings, _) in
                    trainings.forEach({ training in
                        tasks.forEach({ task in
                            if task.trainingId == training.id {
                                task.card = training
                            }
                        })
                    })
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    completion(tasks)
                }
            }
        }
    }
    
    func getTask(id: String, completion: @escaping (TaskEntity?) -> Void) {
        tasksManager.getTasks(by: [id]) { task in
            
            let group = DispatchGroup()
            if task?.cardId != nil {
                group.enter()
                FeedService.shared.getCards(page: nil, cardsIds: [task?.cardId ?? ""], complated: { cards in
                    guard let card = cards.first else { return }
                    task?.card = card
                    group.leave()
                })
            } else if task?.trainingId != nil {
                group.enter()
                TrainingService.shared.getTrainingsByIds(categoryId: "", ids: [task?.trainingId ?? ""]) { (trainings, _) in
                    guard let training = trainings.first else { return }
                    task?.card = training
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(task)
            }
        }
    }
    
    func getTags(page: Int, searchString: String, complated: @escaping ([String]) -> Void) {
        tasksManager.getTags(page: page, searchString: searchString, completion: complated)
    }

    func getTasksCount(completion: @escaping (CardlessTasksEntity?) -> Void) {
        tasksManager.getTasksCount(completion: completion)
    }
    
    private func updateEntityForTask(tasks: [TaskEntity]) {
        guard !tasks.isEmpty, let id = tasks.first?.id else {
            return
        }
        
        taskCompletedPatch(for: id)
    }
    
    func taskCompletedPatch(for taskId: String, completion: EmptyClosure? = nil) {
        tasksManager.postTaskResult(taskId: taskId, result: ["completed": true]) { _ in completion?() }
    }
    
    func tryUpdateCardForTask(cardId: String) {
        loadTasksFromDb(cardId: cardId) { [weak self] tasks in
            self?.updateEntityForTask(tasks: tasks)
        }
    }
    
    func loadTasksByIds(ids: [String], type: MyTasksType, completion: @escaping ([TaskEntity]) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        let idsPredicate = NSPredicate(format: "id IN %@", ids)
        var completedPredicate: NSPredicate
        var overduePredicate: NSPredicate
        
        switch type {
        case .completed:
            completedPredicate = NSPredicate(format: "isCompleted == \(true)")
            overduePredicate = NSPredicate(format: "isOverdue == \(false) OR isOverdue == \(true)")
        case .overdue:
            completedPredicate = NSPredicate(format: "isCompleted == \(false)")
            overduePredicate = NSPredicate(format: "isOverdue == \(true)")
        default:
            completedPredicate = NSPredicate(format: "isCompleted == \(false)")
            overduePredicate = NSPredicate(format: "isOverdue == \(false)")
        }
        
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [idsPredicate, completedPredicate, overduePredicate])
        
        guard let result = try? privateMOC.fetch(fetchRequest),
            let entities = result as? [TaskEntity] else {
            completion([])
            return
        }
        
        completion(entities)
    }
    
    func loadTasksFromDb(cardId: String? = nil, trainingId: String? = nil, complated: @escaping ([TaskEntity]) -> Void) {
        
        var cards = [TaskEntity]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        if let cardId = cardId {
            fetchRequest.predicate = NSPredicate(format: "cardId == %@", cardId)
        }
        if let trainingId = trainingId {
            fetchRequest.predicate = NSPredicate(format: "trainingId == %@", trainingId)
        }
        if let results = try? self.privateMOC.fetch(fetchRequest) {
            for result in (results as? [TaskEntity])! {
                cards.append(result)
            }
        }
        
        complated(cards)
    }
}
