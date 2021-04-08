//
//  DuelsListConfigurator.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 05.04.2021.
//

import Foundation

protocol DuelsListConfiguratorProtocol {
    func configure(viewController: DuelsListViewController)
}

final class DuelsListConfigurator: DuelsListConfiguratorProtocol {
    private let needShowStatistic: Bool
    private let newDuelGameId: String?
    private let cardFromPush: String?
    
    init(needShowStatistic: Bool = false,
         newDuelGameId: String? = nil,
         cardFromPush: String? = nil) {
        
        self.needShowStatistic = needShowStatistic
        self.newDuelGameId = newDuelGameId
        self.cardFromPush = cardFromPush
    }
    
    func configure(viewController: DuelsListViewController) {
        
        let presenter = DuelsListPresenter(
            view: viewController,
            newDuelGameId: newDuelGameId
        )
        
        viewController.presenter = presenter
    }
    
}
