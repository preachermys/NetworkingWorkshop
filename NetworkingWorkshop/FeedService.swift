//
//  FeedService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import UIKit
import CoreData

class FeedService {

    static let shared = FeedService()

    private let feedManager = FeedManager()
    
    var cards = [CardEntity]()
    var posts = [PostModel]()

    var privateMOC: NSManagedObjectContext

    static var textStringFont: [NSAttributedString.Key: Any] {
        let mutableParagraphStyle = NSMutableParagraphStyle()
        // Customize the line spacing for paragraph.
        mutableParagraphStyle.lineSpacing = CGFloat(1.47)
        return [ NSAttributedString.Key.font: UIFont(name: "SFUIText-Regular", size: 15)!,
                 NSAttributedString.Key.paragraphStyle: mutableParagraphStyle]
        
    }

    private init() {
        privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        privateMOC.persistentStoreCoordinator = CoreDataStack.shared.createPersistentStoreCoordinator()
    }
    
    var lastCardUpdate: Int {
        get {
            if let token = UserDefaults.standard.value(forKey: "lastCardUpdate") as? Int {
                return token
            } else {
                return 0
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastCardUpdate")
        }
    }
    
    func getTags(page: Int, searchString: String, complated: @escaping ([String]) -> Void) {
        feedManager.getTags(page: page, searchString: searchString, completion: complated)
    }
    
    static func stringForBlocks(text: String) -> NSAttributedString {
        let mainString = NSAttributedString(string: "\n\(text)\n", attributes: textStringFont)
        return mainString
    }
    
    func getCards(page: Int? = nil, cardsIds: [String]? = nil, complated: @escaping ([CardEntity]) -> Void) {
        var requestIds: [String] = cardsIds ?? []
        if page != nil {
            var upper = 10
            if let count = cardsIds?.count, upper > count {
                upper = count
            }
            requestIds.removeAll()
            requestIds = Array(cardsIds?[0..<upper] ?? [])
        }
        
        feedManager.getCards(with: requestIds, completion: { [weak self] cards in
            cards.forEach({ card in
                guard let post = self?.posts.first(where: { $0.cardIds.first == card.id }) else { return }
                card.postId = post.id
                card.likesCount = Int16(post.likesCount)
                card.favoritesCount = Int16(post.favoritesCount)
                card.published = Date(timeIntervalSince1970: TimeInterval(post.published))
            })
            
            cards.forEach({ card in
                self?.posts.first { post in post.cardIds.first == card.id }?.card = card
            })

            complated(cards)
        })
    }
    
    func getFeeds(
        page: Int,
        tags: [String]?,
        searchString: String?,
        types: [FeedCardType]?,
        complated: @escaping ([PostModel]) -> Void
    ) {
        
        feedManager.getFeedIds(
            page: page,
            timestamp: lastCardUpdate,
            searchTags: tags,
            searchString: searchString,
            types: types
        ) { [weak self] feedIdArray in
            
            guard let self = self else { return }
            self.cards = []
            self.posts = feedIdArray
            let ids = feedIdArray.compactMap({ $0.cardIds.first })
            guard !ids.isEmpty else {
                complated([])
                return
            }
            
            self.getCards(cardsIds: Array(ids)) { cards in
                cards.forEach({ card in
                    guard let post = self.posts.first(where: { postModel in  postModel.cardIds.first == card.id }) else { return }
                    card.postId = post.id
                    card.likesCount = Int16(post.likesCount)
                    card.favoritesCount = Int16(post.favoritesCount)
                    card.published = Date(timeIntervalSince1970: TimeInterval(post.published))
                    card.isLiked = post.isLiked
                    card.isFavorited = post.isFavorited
                })
                
                self.cards.append(contentsOf: cards)
                self.posts = self.posts.filter({ post in post.card != nil })
                complated(self.posts)
            }
        }
    }
    
    func getCardsByIds(ids: [String], completionHandler: @escaping ([CardEntity]) -> Void) {
        feedManager.getPosts(by: ids) { [weak self] dictList in
            let posts = dictList.compactMap({ PostModel(dict: $0) })
            let cardIds = posts.compactMap({ $0.cardIds.first })
            
            self?.feedManager.getCards(with: cardIds, completion: { cards in
                cards.forEach({ card in
                    guard let post = posts.first(where: { $0.cardIds.first == card.id }) else { return }
                    card.postId = post.id
//                    card.favoritesCount = Int16(post.favoritesCount)
//                    card.likesCount = Int16(post.likesCount)
                    card.published = post.publishAt
                })
                
                cards.forEach({ card in
                    self?.posts.first { post in post.cardIds.first == card.id }?.card = card
                })

                completionHandler(cards)
            })
        }
    }

    func loadCardsFromDb(cardsIds: [String]? = nil, complated: @escaping ([CardEntity]) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CardEntity")
        fetchRequest.predicate = NSPredicate(format: "status != %@", "deleted")
        
        guard let results = try? privateMOC.fetch(fetchRequest),
            let cardEntitites = results as? [CardEntity] else {
            complated([])
            return
        }
        
        let cards = cardEntitites.filter({ cardsIds?.contains($0.id ?? "") ?? false })

        cards.forEach({ card in
            self.posts.first { post in post.cardIds.first == card.id }?.card = card
        })
        complated(cards)
    }
    
    func updateCards(types: [FeedCardType]?, postsRefresh: @escaping ([PostModel], [String]?) -> Void) {
        let endDate = Int(Date().timeIntervalSince1970)
        
        getFeeds(page: 0, tags: nil, searchString: nil, types: types) { (posts) in
            if !posts.isEmpty {
                self.lastCardUpdate = endDate
            }
            self.posts = posts
            postsRefresh(posts, nil)
        }
    }
    
    func saveCards() {
         self.privateMOC.perform {
            do {
                try self.privateMOC.save()
            } catch {
                NSLog("==== Save cards context error ====")
            }
        }
    }
}
