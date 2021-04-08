//
//  UserModel.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation
import CoreData
import UIKit
import UserNotifications

class UserModel {
    static let shared = UserModel()
    
    let entityArray = ["AnswerEntity", "AuthorEntity", "CommentEntity", "FeedBackEntity", "IdEntity",
                       "LongReadBlockEntity", "PhotoMarkBlockEntity", "PhotoMarkSpecialEntity",
                       "QuestionEntity", "ReportEntity", "SpecialEntity", "NotificationEntity", "TimeLineBlockEntity",
                       "TrainingCategoryEntity", "AudioCardEntity", "CaseCardEntity", "LongReadCardEntity",
                       "OpenQuestionEntity", "PhotoCardEntity", "PhotoMarkCardEntity", "SurveyEntity", "TestCardEntity",
                       "TimeLineCardEntity", "TrainingEntity", "VideoCardEntity", "FavoriteEntity", "TaskEntity"]
    
    var pushToken: String {
        get {
            if let token = UserDefaults.standard.value(forKey: "pushToken") as? String {
                return token
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "pushToken")
            UserDefaults.standard.synchronize()
        }
    }

    var userId: String? {
        var base64String: String
        if KeychainService.shared.load(with: .token) != "" {
            base64String = KeychainService.shared.load(with: .token)
        } else {
            base64String = RequestInterceptor.shared.tempToken
        }

        if base64String.count % 4 != 0 {
            let padlen = 4 - base64String.count % 4
            base64String += String(repeating: "=", count: padlen)
        }

        if let data = Data(base64Encoded: base64String, options: []),
            let str = String(data: data as Data, encoding: String.Encoding.utf8) {
            let dict = convertToDictionary(text: str)
            
            return dict?["sub"] as? String
        }
        return nil
    }

    var roles: [String] {
        get {
            if let roles = UserDefaults.standard.value(forKey: "roles") as? [String] {
                return roles
            } else {
                return []
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "roles")
            UserDefaults.standard.synchronize()
        }
    }
    
    var groups: [String] {
        get {
            if let groups = UserDefaults.standard.value(forKey: "groups") as? [String] {
                return groups
            } else {
                return []
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "groups")
            UserDefaults.standard.synchronize()
        }
    }

    var email: String {
        get {
            if let email = UserDefaults.standard.value(forKey: "email") as? String {
                return email
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "email")
            UserDefaults.standard.synchronize()
        }
    }

    var username: String {
        get {
            if let username = UserDefaults.standard.value(forKey: "username") as? String {
                return username
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "username")
            UserDefaults.standard.synchronize()
        }
    }

    var image: String {
        get {
            if let image = UserDefaults.standard.value(forKey: "image") as? String {
                return image
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "image")
            UserDefaults.standard.synchronize()
        }
    }

    var firstname: String {
        get {
            if let firstname = UserDefaults.standard.value(forKey: "firstname") as? String {
                return firstname
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "firstname")
            UserDefaults.standard.synchronize()
        }
    }

    var lastname: String {
        get {
            if let lastname = UserDefaults.standard.value(forKey: "lastname") as? String {
                return lastname
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastname")
            UserDefaults.standard.synchronize()
        }
    }

    var middlename: String {
        get {
            if let middlename = UserDefaults.standard.value(forKey: "middlename") as? String {
                return middlename
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "middlename")
            UserDefaults.standard.synchronize()
        }
    }

    var phone: String {
        get {
            if let phone = UserDefaults.standard.value(forKey: "phone") as? String {
                return phone
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "phone")
            UserDefaults.standard.synchronize()
        }
    }

    var position: String {
        get {
            if let position = UserDefaults.standard.value(forKey: "position") as? String {
                return position
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "position")
            UserDefaults.standard.synchronize()
        }
    }

    var location: String {
        get {
            if let location = UserDefaults.standard.value(forKey: "location") as? String {
                return location
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "location")
            UserDefaults.standard.synchronize()
        }
    }

    var department: String {
        get {
            if let department = UserDefaults.standard.value(forKey: "department") as? String {
                return department
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "department")
            UserDefaults.standard.synchronize()
        }
    }

    var hiredAt: String {
        get {
            if let hiredAt = UserDefaults.standard.value(forKey: "hiredAt") as? String {
                return hiredAt
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hiredAt")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isAdmin: Bool {
        get {
            if let position = UserDefaults.standard.value(forKey: "isAdmin") as? Bool {
                return position
            } else {
                return false
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isAdmin")
            UserDefaults.standard.synchronize()
        }
    }
    
    var playerId: String {
        get {
            if let playerId = UserDefaults.standard.value(forKey: "playerId") as? String {
                return playerId
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "playerId")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isAfterUpdate: Bool {
//        let versionFromDefaults = UserDefaults.standard.string(forKey: "currentVersion")
//        if versionFromDefaults == Bundle.main.versionNumber {
//            return false
//        } else {
//            UserDefaults.standard.set(Bundle.main.versionNumber, forKey: "currentVersion")
            return true
//        }
    }
    
    var loggedBefore: Bool {
        get {
            if let id = userId,
                let loggedBefore = UserDefaults.standard.value(forKey: id) as? Bool {
                return loggedBefore
            } else {
                return false
            }
        }
        set {
            if let userId = userId {
                UserDefaults.standard.setValue(newValue, forKey: userId)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    var deviceId: String {
        get {
            if let deviceId = UserDefaults.standard.value(forKey: "deviceId") as? String {
                return deviceId
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "deviceId")
            UserDefaults.standard.synchronize()
        }
    }

    private init() {}

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        return nil
    }
    
//    func convertToUser() -> User {
//        return User(id: userId!, image: image, firstname: firstname, lastname: lastname, middlename: middlename, isActive: true)
//    }
        
    func clearUser() {
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
        UserDefaults.standard.synchronize()
        FavoritesService.shared.fetchedResultsController.delegate = nil
        DuelsService.shared.fetchedResultsController.delegate = nil
        self.deleteAllRecords(entitys: self.entityArray)
    }
    
    func deleteAllRecords(entitys: [String]) {
        let context = CoreDataStack.shared.managedObjectContext
        for entity in entitys {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do {
                try context.execute(deleteRequest)
                TrainingService.shared.privateMOC.reset()
                FeedService.shared.privateMOC.reset()
                DuelsService.shared.privateMOC.reset()
                FavoritesService.shared.privateMOC.reset()
//                NotificationService.shared.privateMOC.reset()
//                ReportService.shared.reset()
                context.reset()
            } catch {
                NSLog("Could not delete \(entity).")
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
//            AnaliticsContainer.shared.analiticsProvider.push(enabled: granted)
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
