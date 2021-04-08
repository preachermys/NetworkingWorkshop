//
//  TrainingService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import UIKit
import CoreData

class TrainingService {
    
    static let shared = TrainingService()
    var privateMOC: NSManagedObjectContext
    
    private let trainingManager = TrainingManager()

    private init() {
        privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        privateMOC.persistentStoreCoordinator = CoreDataStack.shared.createPersistentStoreCoordinator()
    }
    
    func getCategories(page: Int, completion: @escaping ([TrainingCategoryEntity]) -> Void) {
        trainingManager.getTrainingCategories(page: page, completion: completion)
    }
    
    func getAllCategories(completion: @escaping ([TrainingCategoryEntity]) -> Void) {
        trainingManager.getAllCategories(completion: completion)
    }
    
    func getCategory(by id: String, completion: @escaping (TrainingCategoryEntity) -> Void) {
        trainingManager.getCategory(by: id, completion: completion)
    }
    
    func getTrainings(ids: [String], completionHandler: @escaping ([TrainingEntity]) -> Void) {
        guard !ids.isEmpty else {
            completionHandler([])
            return
        }
        trainingManager.getTrainings(by: ids) { [weak self] _ in
            guard let self = self else { return }
            
            self.privateMOC.perform {
                do {
                    if self.privateMOC.hasChanges {
                        try self.privateMOC.save()
                    }
                    
                    self.loadCardsFromDb(tainingIds: ids, completion: completionHandler)
                } catch {
                    NSLog("Failure to save context: \(error)")
                }
            }
        }
    }
    
    func getTrainingsByIds(categoryId: String, ids: [String], complated: @escaping ([TrainingEntity], String) -> Void) {
        if ids.isEmpty {
            complated([], categoryId)
            return
        }
        
        trainingManager.getTrainings(by: ids) { (trainingArray) in
            complated(trainingArray, categoryId)
        }
    }
    
    func loadTrainingsFromDb(cardsIds: [String]? = nil, complated: @escaping ([TrainingEntity]) -> Void) {
        
        var cards = [TrainingEntity]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrainingEntity")
        fetchRequest.predicate = NSPredicate(format: "status != %@ AND taskId == NULL", "deleted")
        
        if let results = try? self.privateMOC.fetch(fetchRequest) {
            for result in (results as? [TrainingEntity])! {
                if let cardsIds = cardsIds, !cardsIds.contains(result.id!) {
                    continue
                }
                if result.type == nil {continue}
                cards.append(result)
            }
        }
        complated(cards)
    }

    func loadCardsFromDb(tainingIds: [String]? = nil, categoryId: String, complated: @escaping ([TrainingEntity], String) -> Void) {
        
        var trainings = [TrainingEntity]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrainingEntity")
        
        if let results = try? privateMOC.fetch(fetchRequest) {
            for result in (results as? [TrainingEntity])! {
                
                if let tainingIds = tainingIds, !tainingIds.contains(result.id!) {
                    continue
                }
                trainings.append(result)
            }
        }
        complated(trainings, categoryId)
    }
    
    func loadCardsFromDb(tainingIds: [String]? = nil, completion: @escaping ([TrainingEntity]) -> Void) {
        var trainings = [TrainingEntity]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrainingEntity")
        
        if let results = try? privateMOC.fetch(fetchRequest),
            let trainingEntities = results as? [TrainingEntity] {
            for result in trainingEntities {
                guard let id = result.id else { return }
                if let tainingIds = tainingIds, !tainingIds.contains(id) {
                    continue
                }
                trainings.append(result)
            }
        }
        completion(trainings)
    }
    
    func saveCards() {
        self.privateMOC.perform {
            do {
                try self.privateMOC.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    func removeTrainingsFromDb() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrainingEntity")
        let result = try? privateMOC.fetch(fetchRequest)
        
        if let resultData = result as? [TrainingEntity] {
            
            resultData.forEach({ privateMOC.delete($0) })
            
            do {
                try TrainingService.shared.privateMOC.save()
            } catch {
                NSLog("Error with deleting Trainings from CoreData in TrainingService")
            }
        }
    }
}

