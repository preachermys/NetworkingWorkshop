//
//  FavoritesService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData
import UIKit

final class FavoritesService: NSObject {
    static let shared = FavoritesService()
    
    typealias FavoritesCountHandler = (Int) -> Void

    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    var fetchedResultsController: NSFetchedResultsController<FavoriteEntity>

    private let favoritesManager = FavoritesManager()
    
    private override init() {
        privateMOC.persistentStoreCoordinator = CoreDataStack.shared.createPersistentStoreCoordinator()
        privateMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        let fetchRequest = NSFetchRequest<FavoriteEntity>(entityName: "FavoriteEntity")
        let sort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController<FavoriteEntity>(fetchRequest: fetchRequest,
                                                       managedObjectContext: privateMOC, sectionNameKeyPath: nil,
                                                       cacheName: nil)
    }

    func getAllFavorites(completionHandler: @escaping ([FavoriteModelData], [FavoriteModelData], [FavoriteModelData]) -> Void) {
        var postsFavorites: [FavoriteModelData] = []
        var trainingsFavorites: [FavoriteModelData] = []
        var duelsFavorites: [FavoriteModelData] = []
        
        let group = DispatchGroup()
        group.enter()
        favoritesManager.getFavorites(.post) { dict in
            postsFavorites.append(contentsOf: dict)
            group.leave()
        }
        
        group.enter()
        favoritesManager.getFavorites(.training) { dict in
            trainingsFavorites.append(contentsOf: dict)
            group.leave()
        }
        
        group.enter()
        favoritesManager.getFavorites(.duel) { dict in
            duelsFavorites.append(contentsOf: dict)
            group.leave()
        }
        
        group.notify(queue: .global(qos: .userInitiated)) {
            let sortedPostModels = postsFavorites.sorted(by: { $0.created?.toDate() ?? Date() > $1.created?.toDate() ?? Date() })
            let sortedTrainingModels = trainingsFavorites.sorted(by: { $0.created?.toDate() ?? Date() > $1.created?.toDate() ?? Date() })
            let sortedDuelsModels = duelsFavorites.sorted(by: { $0.created?.toDate() ?? Date() > $1.created?.toDate() ?? Date() })

            completionHandler(sortedPostModels, sortedTrainingModels, sortedDuelsModels)
        }
    }
    
    func getFavorites(
        _ type: FavoritesRouter.FavoriteRequestType,
        completion: @escaping ([FavoriteModelData]) -> Void
    ) {
        favoritesManager.getFavorites(type, completion: completion)
    }
    
    func getFavoritesCount(completionHandler: @escaping FavoritesCountHandler) {
        favoritesManager.getFavoritesCount(completion: completionHandler)
    }
    
    func retrieveFavorites(type: FavoriteType, completionHandler: ([FavoriteEntity]) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteEntity")
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.stringValue())
        guard let results = try? privateMOC.fetch(fetchRequest),
            let favorites = results as? [FavoriteEntity] else {
                completionHandler([])
                return
        }
        completionHandler(favorites)
    }

    func isModelInFavorites(id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteEntity")
        fetchRequest.predicate = NSPredicate(format: "entityId == %@", id)
        guard let results = try? privateMOC.fetch(fetchRequest) else {
            return false
        }
        return results.count > 0
    }

    private func saveFavoriteEntities(from dict: [[String: Any]], with type: FavoriteType) {
        DispatchQueue.main.async {
            self.privateMOC.perform {
                for data in dict {
                    let entityDescription = NSEntityDescription.entity(forEntityName: "FavoriteEntity", in: (FavoritesService.shared.privateMOC))
                    let managedObject = FavoriteEntity.init(entity: entityDescription!, insertInto: FavoritesService.shared.privateMOC)
                    managedObject.updateFromDict(dict: data)
                    managedObject.type = type.stringValue()
                }
            }
        }
    }
    
    private func showError(_ error: LinkError?) {
        DispatchQueue.main.async {
            guard let error = error else { return }
//            UniversalLinkRouter.shared.handleLinkWithError(error)
        }
    }
}

extension String {
    
    func toUTCDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }
    
    static func toDateUTCString(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: date)
    }
    
    
    static func toStringTimeFormat(time: Double) -> String {
        if time < 10000 {
            let minute = Int(time / 60)
            let seconds = Int(time.truncatingRemainder(dividingBy: 60))
            let minuteStr = minute >= 10 ? "\(minute)" : "0\(minute)"
            let secondsStr = seconds >= 10 ? "\(seconds)" : "0\(seconds)"
            return minuteStr + ":" + secondsStr
        } else {
            return "00:00"
        }
    }

    func convertDateFormater() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return  dateFormatter.string(from: date!)

    }

    func convertFromHTML() -> String {
        var text = self.replacingOccurrences(of: "<p></p>", with: "\n")
            .replacingOccurrences(of: "<p>", with: "")
            .replacingOccurrences(of: "</p>", with: "\n")
            .replacingOccurrences(of: "<br>", with: "\n")
        text = text.removeNewLines()
        return text
    }
    
    mutating func convertBullets() -> String {
        while let start = self.range(of: "<ul><li>"),
            let end = self.range(of: "</li></ul>", range: start.upperBound ..< self.endIndex) {
            
            let range = start.upperBound..<end.lowerBound
            let substring = "  • " + self[range]
            let newSub = substring.replacingOccurrences(of: "</li><li>", with: "\n  • ")
            
            self.replaceSubrange(range, with: newSub + "\n")
            
            if let range = self.range(of: "<ul><li>") {
                self.replaceSubrange(range, with: "")
                
                if let endRange = self.range(of: "</li></ul>") {
                    self.replaceSubrange(endRange, with: "")
                }
            }
        }
        
        convertDigitBullets()
        return self
    }
    
    private mutating func convertDigitBullets() {
        while let start = self.range(of: "<ol><li>"),
            let end = self.range(of: "</li></ol>", range: start.upperBound ..< self.endIndex) {
            
            let range = start.upperBound..<end.lowerBound
            var substring = "  1. " + self[range]
            
            var value: Int = 2
            
            while let range = substring.range(of: "</li><li>") {
                substring.replaceSubrange(range, with: "\n  \(value). ")
                value += 1
            }
            
            self.replaceSubrange(range, with: substring + "\n")
                        
            if let range = self.range(of: "<ol><li>") {
                self.replaceSubrange(range, with: "")
                
                if let endRange = self.range(of: "</li></ol>") {
                    self.replaceSubrange(endRange, with: "")
                }
            }
        }
    }

    func removeNewLines() -> String {
        var text = self
        while true {
            if text.hasPrefix("\n") {
                text.remove(at: text.startIndex)
            } else {
                break
            }
        }
        while true {
            if text.hasSuffix("\n") {
                text.removeLast(1)
            } else {
                break
            }
        }
        return text
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font], context: nil
        )

        return ceil(boundingBox.height)
    }
}
