//
//  FeedWorker.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import Foundation

final class FeedWorker {
    
    private var filteredPosts: [PostModel] = []
    private var favoriteCards: [String] = []
    private var currentPage = 0
    
    private let feedManager = FeedManager()
    
    var proxyPosts: [PostModel] {
        return filteredPosts
    }
    
    func getLikedPosts(completionHandler: @escaping (Bool) -> Void) {
        completionHandler(false)
    }
    
    func getFeedData(types: [FeedCardType]?, completionHandler: @escaping (Bool) -> Void) {
        let localGroup = DispatchGroup()
        localGroup.enter()
        FeedService.shared.getFeeds(page: 0, tags: nil, searchString: nil, types: types) { [weak self] cards in
            self?.filteredPosts = cards.sorted(by: { card1, card2 in
                return card1.published > card2.published
            })
            self?.currentPage += 1
            localGroup.leave()
        }
        
        localGroup.notify(queue: .global()) { [weak self] in
                self?.getLikedPosts(completionHandler: { isEmpty in
                    completionHandler(isEmpty)
                })
        }
    }
    
    func updateFeedData(types: [FeedCardType]?, completionHandler: @escaping () -> Void) {
        FeedService.shared.updateCards(types: types, postsRefresh: { [weak self] posts, _  in
            guard let self = self else { return }
            
            self.filteredPosts = posts.sorted(by: { (card1, card2) in
                card1.published > card2.published
            })
        })
    }
    
    func getPaginatedFeedData(types: [FeedCardType]?, completionHandler: @escaping (Bool) -> Void) {
        if self.currentPage == Int.max {
            completionHandler(false)
            return
        }
        
        FeedService.shared.getFeeds(page: currentPage, tags: nil, searchString: nil, types: types) { [weak self] cards in
            guard let self = self else { return }
            self.filteredPosts += cards
            
            !cards.isEmpty
                ? (self.currentPage += 1)
                : (self.currentPage = Int.max)
            
            self.filteredPosts = self.filteredPosts.sorted(by: { card1, card2 in
                return card1.published > card2.published
            })
        }
    }
    
    var cardsCount: Int {
        return filteredPosts.count
    }
    
    func getPostType(at index: Int) -> FeedType {
        guard let feedString = filteredPosts[index].card?.type else {
            return FeedType(string: "")
        }
        
        return FeedType(string: feedString)
    }
    
    func cardModel(for index: Int) -> CardEntity {
        return filteredPosts[index].card!
    }
}

