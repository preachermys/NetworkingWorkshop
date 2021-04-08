//
//  LogoutService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import CoreData
import UIKit

final class LogoutService {
    static let shared = LogoutService()
    
    private let entityArray = ["AnswerEntity",
                       "AuthorEntity",
                       "CommentEntity",
                       "CardEntity",
                       "FeedBackEntity",
                       "IdEntity",
                       "LongReadBlockEntity",
                       "PhotoMarkBlockEntity",
                       "PhotoMarkSpecialEntity",
                       "QuestionEntity",
                       "ReportEntity",
                       "SpecialEntity",
                       "NotificationEntity",
                       "TimeLineBlockEntity",
                       "TrainingCategoryEntity",
                       "AudioCardEntity",
                       "CaseCardEntity",
                       "LongReadCardEntity",
                       "OpenQuestionEntity",
                       "PhotoCardEntity",
                       "PhotoMarkCardEntity",
                       "SurveyEntity",
                       "TestCardEntity",
                       "TimeLineCardEntity",
                       "TrainingEntity",
                       "VideoCardEntity",
                       "FavoriteEntity",
                       "TaskEntity"]
    
    var isSignedIn: Bool = true
    
    private let userManager = UserManager()
    
    func logout() {
        guard isSignedIn else { return }
//        AnaliticsContainer.shared.analiticsProvider.logOut()
//        NotificationService.shared.removeOnesignalSettings()
        UserService.shared.removeSession(sessionId: UserModel.shared.deviceId) { _ in }
        KeychainService.shared.deleteItem(for: .deviceId)
        
        if !UserModel.shared.pushToken.isEmpty {
            userManager.removePushToken(pushToken: UserModel.shared.pushToken) { }
        }
        
        clearData()
        isSignedIn = false
    }
    
    private func clearData() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
            HTTPCookieStorage.shared.setCookies([], for:
                URL(string: NetworkConstants.baseAuthUrl + "oauth/authorize")!, mainDocumentURL: nil)
            KeychainService.shared.deleteItem(for: .token)
            KeychainService.shared.deleteItem(for: .refreshToken)
            UserDefaults.standard.set(nil, forKey: "lastTrainingUpdate")
            UserDefaults.standard.set(nil, forKey: "token")
            UserDefaults.standard.set(nil, forKey: "pushToken")
            UserDefaults.standard.set(nil, forKey: "roles")
            UserDefaults.standard.set(nil, forKey: "email")
            UserDefaults.standard.set(nil, forKey: "username")
            UserDefaults.standard.set(nil, forKey: "image")
            UserDefaults.standard.set(nil, forKey: "firstname")
            UserDefaults.standard.set(nil, forKey: "lastname")
            UserDefaults.standard.set(nil, forKey: "middlename")
            UserDefaults.standard.set(nil, forKey: "phone")
            UserDefaults.standard.set(nil, forKey: "location")
            UserDefaults.standard.set(nil, forKey: "department")
            UserDefaults.standard.set(nil, forKey: "hiredAt")
            UserDefaults.standard.set(nil, forKey: "lastCardUpdate")
            UserDefaults.standard.set(nil, forKey: "playerId")
            UserDefaults.standard.set(nil, forKey: "deviceId")

            UserDefaults.standard.synchronize()
            self.deleteAllRecords(entitys: self.entityArray)
        }
    }
    
    private func deleteAllRecords(entitys: [String]) {
        let context = CoreDataStack.shared.managedObjectContext
        for entity in entitys {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do {
                try context.execute(deleteRequest)
                context.reset()
            } catch {
                NSLog("----- COULD NOT DELETE \(entity). -----")
            }
        }
        
        TrainingService.shared.privateMOC.performAndWait {
            TrainingService.shared.privateMOC.reset()
        }
        
        FeedService.shared.privateMOC.performAndWait {
            FeedService.shared.privateMOC.reset()
        }

        DuelsService.shared.privateMOC.performAndWait {
            DuelsService.shared.privateMOC.reset()
        }

        FavoritesService.shared.privateMOC.performAndWait {
            FavoritesService.shared.privateMOC.reset()
        }

//        NotificationService.shared.privateMOC.performAndWait {
//            NotificationService.shared.privateMOC.reset()
//        }
//
//        ReportService.shared.reset()
    }
}
