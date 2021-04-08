//
//  DuelsService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData
import UIKit

struct AnsweredQuestion {
    struct Answer {
        let id: String
        let timestamp: Int
    }
    let id: String
    let answer: Answer
}

class DuelsService {

    static let shared = DuelsService()
    var duels = [DuelEntity]()
    var finishedDuelsIds: [String] = []
    var duelStartedIds: [String?] = []
    var deletedDuels: [DuelEntity] = []
        
    private let duelsManager = DuelsManager()
    
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    var isRequestStarted = false

    var fetchedResultsController: NSFetchedResultsController<DuelEntity>
    
    private init() {
        privateMOC.persistentStoreCoordinator = CoreDataStack.shared.createPersistentStoreCoordinator()
        privateMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let fetchRequest = NSFetchRequest<DuelEntity>(entityName: "DuelEntity")
        let sort = NSSortDescriptor(key: "publishedAt", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchedResultsController = NSFetchedResultsController<DuelEntity>(fetchRequest: fetchRequest,
                                                                          managedObjectContext: privateMOC,
                                                                          sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func getDuelForId(duelId: String) -> DuelEntity? {
        guard let duel = duels.first(where: { $0.id == duelId }) else { return nil }
        return duel
    }
    
    func getDuelsByIds(ids: [String], completionHandler: @escaping ([DuelEntity]) -> Void) {
        if !isRequestStarted {
            isRequestStarted = true
            duelsManager.getDuels(by: 0) { [weak self] duels in
                self?.isRequestStarted = false
                completionHandler(duels)
            }
        }
    }
    
    func getDuelsBy(ids: [String], completionHandler: @escaping ([DuelEntity]) -> Void) {
        if !isRequestStarted {
            isRequestStarted = true
            duelsManager.getDuels(by: ids) { [weak self] duels in
                self?.isRequestStarted = false
                
                completionHandler(duels)
            }
        }
    }
    
    func getDuels(page: Int, complation: @escaping ([DuelEntity]) -> Void) {
        if !isRequestStarted {
            isRequestStarted = true
            duelsManager.getDuels(by: page) { (duels) in
                self.isRequestStarted = false
                complation(duels)
            }
        }
    }

    func postDuelGameFinish(gameId: String,
                            gameEnd: Int,
                            gameStart: Int,
                            answers: [AnsweredQuestion],
                            completion: @escaping () -> ()) {
        var dict = [String: Any]()
        dict["game_end"] = gameEnd
        dict["game_start"] = gameStart
        dict["game_id"] = gameId
        var gameAnswers = [[String: Any]]()
        for answer in answers {
            var dict = [String: Any]()
            dict["id"] = answer.id
            var answerDict = [String: Any]()
            answerDict["id"] = answer.answer.id
            answerDict["timestamp"] = answer.answer.timestamp
            dict["answer"] = answerDict
            gameAnswers.append(dict)
        }
        dict["questions"] = gameAnswers
        finishedDuelsIds.append(gameId)
    }
    
    func loadDuelsFromDb(duelIds: [String]? = nil, complated: @escaping ([DuelEntity]) -> Void) {
        var fetchedDuels: [DuelEntity] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DuelEntity")
        guard let results = try? privateMOC.fetch(fetchRequest),
            let duelsList = results as? [DuelEntity] else { return }

        if duelIds != nil {
            fetchedDuels = duelsList.filter({ duelIds?.contains($0.id ?? "") ?? false })
        } else {
            fetchedDuels = duelsList
        }
        
        duels = fetchedDuels
        complated(duels)
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
}
