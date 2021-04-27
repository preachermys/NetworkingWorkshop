//
//  DuelsWorker.swift
//  NetworkingWorkshop
//
//  Created by Юлия Милованова on 05.04.2021.
//

import Foundation

final class DuelsWorker {
    
    var totalDuels = 0
    private var duels: [DuelEntity] = []
    var activeDuels: [DuelGameModel]?
    private var currentPage: Int = 1
    
    var proxyDuels: [DuelEntity] {
        return duels
    }
    
    // MARK: - Notifications
    
    func reloadWithNotification(completionHandler: @escaping (Int) -> Void) {
        _ = NotificationCenter
            .default
            .addObserver(
                forName: Notification.Name("reloadDuelCell"),
                object: nil,
                queue: OperationQueue.main
            ) { [weak self] notification in
                
                if let index = self?.duels.firstIndex(where: { duel in duel.id == (notification.object as? DuelEntity)?.id }) {
                    if let duelEntity = notification.object as? DuelEntity {
                        self?.duels[index] = duelEntity
                        completionHandler(index)
                    }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadDuelCell"), object: nil)
    }
    
    // MARK: - Duels data
    
    func refreshView(completionHandler: @escaping (Bool) -> Void) {
        let localDispatchGroup = DispatchGroup()
        
        // Получение дуэлей
        localDispatchGroup.enter()
        DuelsService.shared.getDuels(page: 0) { [weak self] duels in
            self?.duels = duels
                            .sorted(by: { first, second in
                                guard
                                    let firstPublished = first.publishedAt?.toUTCDate(),
                                    let secondPublished = second.publishedAt?.toUTCDate() else { return false }
                                return firstPublished > secondPublished
                            })
            self?.currentPage = 1
            localDispatchGroup.leave()
        }
    }
    
    func getPaginatedDuels(completionHandler: @escaping () -> Void) {
        if currentPage == Int.max {
            completionHandler()
            return
        }
        
        DuelsService.shared.getDuels(page: currentPage) { [weak self] (duels) in
            self?.duels += duels
            
            !duels.isEmpty
                ? (self?.currentPage += 1)
                : (self?.currentPage = Int.max)
            
            guard let safeDuels = self?.duels else { return }
            self?.duels = safeDuels
                .sorted(by: { first, second in
                    guard
                        let firstPublished = first.publishedAt?.toUTCDate(),
                        let secondPublished = second.publishedAt?.toUTCDate() else { return false }
                    return firstPublished > secondPublished
                })

            self?.getFavoriteDuels {
                self?.getLikedDuels(completionHandler: { _ in
                    completionHandler()
                })
            }
        }
    }
    
    func getLikedDuels(completionHandler: @escaping (Bool) -> Void) {
//        guard !duels.isEmpty else {
//            completionHandler(true)
//            return
//        }
//
//        LikesService.shared.getLikedDuels { [weak self] likedDuels in
//            self?.duels.forEach({ duel in
//                duel.isLiked = likedDuels.contains(duel.id ?? "")
//            })
//
//            if let count = self?.duels.count {
//                completionHandler(count == 0)
//            }
//        }
    }
    
    func getFavoriteDuels(completionHandler: () -> Void) {
//        guard !duels.isEmpty else {
//            completionHandler()
//            return
//        }
//
//        duels.forEach({ duel in
//            duel.isFavorited =
//                FavoritesService.shared.isModelInFavorites(id: duel.id ?? "")
//                && duel.favoritesCount > 0
//        })
//
//        completionHandler()
    }
    
    func refreshList(completionHandler: @escaping (Bool) -> Void) {
        let localDispatchGroup = DispatchGroup()
        localDispatchGroup.enter()
//        DuelsService.shared.getDuelStat { [weak self] duelsStat in
//            self?.totalDuels = duelsStat?.clearGamesCount ?? 0
//            localDispatchGroup.leave()
//        }
        
//        localDispatchGroup.enter()
//        DuelsService.shared.getDuels(page: 0) { _ in
//            DuelsService.shared.getDuelGames { [weak self] games in
//                self?.activeDuels = games
//                localDispatchGroup.leave()
//            }
//        }
        
        localDispatchGroup.notify(queue: .main) { [weak self] in
            let isEmpty = self?.duels.isEmpty ?? true
            completionHandler(isEmpty)
        }
    }
    
    // MARK: - TableView data
    
    func duelsCount() -> Int {
        return duels.count
    }
    
    func getDuel(for index: Int) -> DuelEntity {
        return duels[index]
    }
}
