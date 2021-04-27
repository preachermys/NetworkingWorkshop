//
//  TrainingsListConfigurator.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 15.04.2021.
//

import Foundation

protocol TrainingsListConfiguratorProtocol {
    func configure(viewController: TrainingsListViewController)
}

final class TrainingsListConfigurator: TrainingsListConfiguratorProtocol {
    private let pushTrainingId: String?
    
    init(pushTrainingId: String? = nil) {
        self.pushTrainingId = pushTrainingId
    }
    
    func configure(viewController: TrainingsListViewController) {
//        let router = TrainingsListRouter(viewController: viewController)
//
//        let reportService = ReportServiceImpl()
        
        let presenter = TrainingsListPresenter(
            view: viewController,
            pushTrainingId: pushTrainingId
//            router: router,
//            reportService: reportService
        )
        
        viewController.presenter = presenter
    }
    
}
