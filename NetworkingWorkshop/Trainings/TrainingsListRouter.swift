//
//  TrainingsListRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 15.04.2021.
//

//import UIKit
//
//protocol TrainingsListRouterProtocol: CommonRouter {
////    func showEmptyView(needShow: Bool, state: EmptyCardDataState)
////    func openFromPush(vc: TrainingMainViewController)
//    
//    func presentTrainingMainScreen(trainingModel: TrainingEntity?, categoryName: String?)
//    func presentTrainingsSectionScreen(
//        trainingsCount: Int,
//        trainings: [TrainingEntity],
//        trainingCategory: TrainingCategoryEntity?
//    )
//    
//    func presentCategoriesList()
//}
//
//final class TrainingsListRouter: CommonRouterImplementation, TrainingsListRouterProtocol {
//    
////    func showEmptyView(needShow: Bool, state: EmptyCardDataState) {
////        viewController?.showEmptyView(neadShow: needShow, state: state)
////    }
////    
////    func openFromPush(vc: TrainingMainViewController) {
////        DispatchQueue.main.async {
////            if let prVc = self.viewController?.presentedViewController {
////                prVc.dismiss(animated: false)
////            }
////            
////            self.popToRoot(animated: false)
////            
////            let navController = SSNavigationController(rootViewController: vc)
////            navController.modalPresentationStyle = .fullScreen
////            self.present(viewController: navController, animated: true)
////        }
////    }
//    
//    func presentTrainingMainScreen(trainingModel: TrainingEntity?, categoryName: String?) {
//        let vc = TrainingMainViewController.instantiateFrom(appStoryboard: .trainingMain)
//
//        vc.configurator = TrainingMainConfigurator(
//            trainingModel: trainingModel,
//            categoryName: categoryName
//        )
//        
//        push(vc)
//    }
//    
//    func presentTrainingsSectionScreen(
//        trainingsCount: Int,
//        trainings: [TrainingEntity],
//        trainingCategory: TrainingCategoryEntity?
//    ) {
//        let trainingsCategory = TrainingsCategoryViewController
//            .instantiateFrom(appStoryboard: .trainingsCategory)
//        
//        trainingsCategory.configurator = TrainingsCategoryConfigurator(
//            trainingCategory: trainingCategory,
//            trainings: trainings,
//            maxTrainingsCount: trainingsCount
//        )
//
//        push(trainingsCategory)
//    }
//    
//    func presentCategoriesList() {
//        let categoriesListVC = CategoriesListViewController
//            .instantiateFrom(appStoryboard: .categoriesList)
//        
//        categoriesListVC.configurator = CategoriesListConfigurator()
//        
//        navController?.viewControllers.removeAll(where: { $0 is CategoriesListViewController })
//        
//        push(categoriesListVC)
//    }
//}
