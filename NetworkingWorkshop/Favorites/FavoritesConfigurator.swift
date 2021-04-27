//
//  FavoritesConfigurator.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 15.04.2021.
//

import Foundation

protocol FavoritesConfiguratorProtocol {
    func configure(viewController: FavoritesViewController)
}

final class FavoritesConfigurator: FavoritesConfiguratorProtocol {
    let cellConfiguratorUseCase = CellConfiguratorUseCaseImplementation()
    
    func configure(viewController: FavoritesViewController) {
//        let router = FavoritesNavRouter(viewController: viewController)
//        
//        let reportService = ReportServiceImpl()
        
        let presenter = FavoritesPresenter(
            view: viewController,
            cellConfiguratorUseCase: cellConfiguratorUseCase
//            router: router,
//            reportService: reportService
        )
        
        viewController.presenter = presenter
    }
    
}
