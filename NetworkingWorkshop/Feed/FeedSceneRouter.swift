//
//  FeedSceneRouter.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 09.04.2021.
//

import UIKit

//protocol FeedSceneRouterProtocol: OpenCardRouter {
//    func showShareActivity(shareUrl: String)
//    func presentCommentScreen(
//        with cellIndex: Int,
//        card: CardEntity,
//        needShowComments: Bool,
//        delegate: CommentDelegate,
//        feedTypeText: String?
//    )
//
//    func presentToast(with text: String)
//
//    func presentFiltersScreen(selectedTypes: [FeedCardType]?, delegate: FilterDelegate)
//}

//final class FeedSceneRouter: CommonRouterImplementation, FeedSceneRouterProtocol {
//
//    func showShareActivity(shareUrl: String) {
//        ShareManager.shared.showActivity(shareUrl: shareUrl,
//                                         parentController: viewController)
//    }
//
//    func presentToast(with text: String) {
//        let toastView = ToastService.toastView(with: text)
//        navController?.view.showToast(toastView,
//                                      duration: 3,
//                                      position: CSToastPositionCenter,
//                                      completion: nil)
//    }
//
//    func presentCommentScreen(
//        with cellIndex: Int,
//        card: CardEntity,
//        needShowComments: Bool,
//        delegate: CommentDelegate,
//        feedTypeText: String?
//    ) {
//        let commentVC = CommentViewController.instantiateFrom(appStoryboard: .comment)
//
//        commentVC.configurator = CommentConfigurator(
//            cardModel: card,
//            cellIndex: cellIndex,
//            needShowComments: needShowComments,
//            feedTypeText: feedTypeText,
//            commentDelegate: delegate
//        )
//
//        commentVC.setDelegate(delegate: delegate)
//        commentVC.cardModel = card
//        commentVC.neadShowComments = needShowComments
//        commentVC.feedTypeText = feedTypeText
//        commentVC.cellIndex = cellIndex
//
//        let navigationController = SSNavigationController(rootViewController: commentVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        viewController?.present(navigationController, animated: true)
//    }
//}

//protocol OpenCardRouter: CommonRouter {
//    func presentLongReadScreen(with card: LongReadCardEntity?, cardModelProperties: CardEntityModel)
//    func presentAudioScreen(with card: AudioCardEntity?, cardModelProperties: CardEntityModel)
//    func presentVideoScreen(with card: VideoCardEntity?, cardModelProperties: CardEntityModel)
//    func presentTimelineScreen(with card: TimeLineCardEntity?, cardModelProperties: CardEntityModel)
//    func presentPhotoTagsScreen(with card: PhotoMarkCardEntity?, cardModelProperties: CardEntityModel)
//    func presentTestScreen(with card: TestCardEntity?, cardModelProperties: CardEntityModel)
//    func presentCaseScreen(with card: CaseCardEntity?, cardModelProperties: CardEntityModel)
//    func presentPhotoScreen(with card: PhotoCardEntity?, cardModelProperties: CardEntityModel)
//    func presentSurveyScreen(with card: SurveyEntity?, cardModelProperties: CardEntityModel)
//    func presentOpenQuestionScreen(with card: OpenQuestionEntity?, cardModelProperties: CardEntityModel)
//    func presentTrainingScreen(with card: CardEntity?, cardModelProperties: CardEntityModel)
//    func presentDuelScreen(with card: DuelEntity?, cardModelProperties: CardEntityModel)
//}

//extension OpenCardRouter {
//    func presentLongReadScreen(with card: LongReadCardEntity?, cardModelProperties: CardEntityModel) {
//        let longreadVC = LongreadViewController.instantiateFrom(appStoryboard: .longread)
//
//        longreadVC.configurator = LongreadConfigurator(
//            cardModel: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId,
//            cellIndex: cardModelProperties.cellIndex,
//            taskCompletionDelegate: cardModelProperties.taskCompletion
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: longreadVC)
//        } else {
//            push(longreadVC)
//        }
//    }
//
//    func presentAudioScreen(with card: AudioCardEntity?, cardModelProperties: CardEntityModel) {
//        let audioVC = AudioViewController.instantiateFrom(appStoryboard: .audio)
//
//        audioVC.configurator = AudioConfigurator(
//            cardModel: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId,
//            cellIndex: cardModelProperties.cellIndex,
//            taskDelegate: cardModelProperties.taskCompletion
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: audioVC)
//        } else {
//            push(audioVC)
//        }
//    }
//
//    func presentVideoScreen(with card: VideoCardEntity?, cardModelProperties: CardEntityModel) {
//        let videoVC = VideoViewController.instantiateFrom(appStoryboard: .video)
//        videoVC.configurator = VideoConfigurator(
//            cardModel: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId,
//            cellIndex: cardModelProperties.cellIndex,
//            taskDelegate: cardModelProperties.taskCompletion
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: videoVC)
//        } else {
//            push(videoVC)
//        }
//    }
//
//    func presentTimelineScreen(with card: TimeLineCardEntity?, cardModelProperties: CardEntityModel) {
//        let timelineVC = TimelineViewController.instantiateFrom(appStoryboard: .timeline)
//
//        timelineVC.configurator = TimelineConfigurator(
//            cardModel: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId,
//            cellIndex: cardModelProperties.cellIndex,
//            taskCompletionDelegate: cardModelProperties.taskCompletion
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: timelineVC)
//        } else {
//            push(timelineVC)
//        }
//    }
//
//    func presentPhotoTagsScreen(with card: PhotoMarkCardEntity?, cardModelProperties: CardEntityModel) {
//        let photoTagsVC = PhotoTagsViewController.instantiateFrom(appStoryboard: .photoTags)
//
//        photoTagsVC.configurator = PhotoTagsConfigurator(
//            cardModel: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId,
//            taskCompletionClosure: cardModelProperties.taskCompletion,
//            cellIndex: cardModelProperties.cellIndex
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: photoTagsVC)
//        } else {
//            push(photoTagsVC)
//        }
//    }
//
//    func presentTestScreen(with card: TestCardEntity?, cardModelProperties: CardEntityModel) {
//        let testVC = TestViewController.instantiateFrom(appStoryboard: .test)
//
//        testVC.configurator = TestConfigurator(
//            cardModel: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId,
//            taskCompleted: cardModelProperties.taskCompletion,
//            cellIndex: cardModelProperties.cellIndex
//        )
//
//        if cardModelProperties.openFromPush {
//            if var topController = UIApplication.shared.keyWindow?.rootViewController {
//                while let presentedViewController = topController.presentedViewController {
//                    topController = presentedViewController
//                }
//
//                testVC.modalPresentationStyle = .fullScreen
//
//                if !Thread.current.isMainThread {
//                    DispatchQueue.main.async {
//                        let navController = SSNavigationController(rootViewController: testVC)
//                        navController.modalPresentationStyle = .fullScreen
//                        topController.present(navController, animated: true)
//                    }
//                } else {
//                    let navController = SSNavigationController(rootViewController: testVC)
//                    navController.modalPresentationStyle = .fullScreen
//                    topController.present(navController, animated: true)
//                }
//            }
//        } else {
//            let navController = SSNavigationController(rootViewController: testVC)
//            navController.modalPresentationStyle = .fullScreen
//            viewController?.present(navController, animated: true)
//        }
//    }
//
//    func presentCaseScreen(with card: CaseCardEntity?, cardModelProperties: CardEntityModel) {
//        let caseVC = CaseViewController.instantiateFrom(appStoryboard: .case)
//
//        caseVC.configurator = CaseConfigurator(
//            cardModel: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            cellIndex: cardModelProperties.cellIndex,
//            taskCompletionDelegate: cardModelProperties.taskCompletion,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: caseVC)
//        } else {
//            let navController = SSNavigationController(rootViewController: caseVC)
//            navController.modalPresentationStyle = .fullScreen
//            viewController?.present(navController, animated: true)
//        }
//    }
//
//    func presentPhotoScreen(with card: PhotoCardEntity?, cardModelProperties: CardEntityModel) {
//        let photoVC = PhotoViewController.instantiateFrom(appStoryboard: .photo)
//
//        photoVC.configurator = PhotoConfigurator(
//            cardModel: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId,
//            cellIndex: cardModelProperties.cellIndex,
//            taskCompletionDelegate: cardModelProperties.taskCompletion
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: photoVC)
//        } else {
//            push(photoVC)
//        }
//    }
//
//    func presentSurveyScreen(with card: SurveyEntity?, cardModelProperties: CardEntityModel) {
//        let surveyVC = SurveyViewController.instantiateFrom(appStoryboard: .survey)
//
//        surveyVC.configurator = SurveyConfigurator(
//            card: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            surveyDelegate: cardModelProperties.surveyDelegate,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId,
//            cellIndex: cardModelProperties.cellIndex,
//            taskCompletionDelegate: cardModelProperties.taskCompletion
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: surveyVC)
//        } else {
//            push(surveyVC)
//        }
//    }
//
//    func presentOpenQuestionScreen(with card: OpenQuestionEntity?, cardModelProperties: CardEntityModel) {
//        let openQuestionVC = OpenQuestionViewController
//            .instantiateFrom(appStoryboard: .openQuestion)
//
//        openQuestionVC.configurator = OpenQuestionConfigurator(
//            cardModel: card,
//            cardSourceType: cardModelProperties.cardSourceType,
//            commentDelegate: cardModelProperties.commentClosure,
//            taskId: cardModelProperties.taskId,
//            trainingId: cardModelProperties.trainingId,
//            cellIndex: cardModelProperties.cellIndex,
//            taskCompletion: cardModelProperties.taskCompletion
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: openQuestionVC)
//        } else {
//            push(openQuestionVC)
//        }
//    }
//
//    func presentTrainingScreen(with card: CardEntity?, cardModelProperties: CardEntityModel) {
//        let trainingMainViewController = TrainingMainViewController
//            .instantiateFrom(appStoryboard: .trainingMain)
//
//        trainingMainViewController.configurator = TrainingMainConfigurator(
//            trainingModel: card as? TrainingEntity,
//            tasksId: cardModelProperties.taskId,
//            cellIndex: cardModelProperties.cellIndex,
//            taskCompletionDelegate: cardModelProperties.taskCompletion
//        )
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: trainingMainViewController)
//        } else {
//            push(trainingMainViewController)
//        }
//    }
//
//    func presentDuelScreen(with card: DuelEntity?, cardModelProperties: CardEntityModel) {
//        let duelCover = DuelCoverViewController.instantiateFrom(appStoryboard: .duelCover)
//
//        duelCover.configurator = DuelCoverConfigurator(duelModel: card)
//
//        if cardModelProperties.openFromPush {
//            presentFromPush(viewController: duelCover)
//        } else {
//            push(duelCover)
//        }
//    }
//
//    func presentFiltersScreen(selectedTypes: [FeedCardType]?, delegate: FilterDelegate) {
//        let filtersVC = FiltersViewController.instantiateFrom(appStoryboard: .filters)
//
//        filtersVC.configurator = FiltersConfigurator(
//            selectedTypes: selectedTypes,
//            delegate: delegate
//        )
//
//        push(filtersVC)
//    }
//}

struct CardEntityModel {
    let taskId: String?
    let trainingId: String?
//    let cardSourceType: CardSourceType?
    let cellIndex: Int?
//    let taskCompletion: TaskProtocol?
//    let commentClosure: CommentDelegate?
//    let surveyDelegate: SurveyDelegate?
//    let openFromPush: Bool
}

