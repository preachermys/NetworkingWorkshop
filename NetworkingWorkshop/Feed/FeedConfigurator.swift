//
//  FeedConfigurator.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import Foundation

protocol FeedConfiguratorProtocol {
    func configure(feedViewController: FeedViewController)
}

final class FeedConfigurator: FeedConfiguratorProtocol {
    
    func configure(feedViewController: FeedViewController) {
        let feedWorker = FeedWorker()
        
        let cellConfiguratorUseCase = CellConfiguratorUseCaseImplementation()
        
        let presenter = FeedPresenter(
            view: feedViewController,
            feedWorker: feedWorker,
            cellConfiguratorUseCase: cellConfiguratorUseCase
        )
        
        feedViewController.presenter = presenter
    }
}
