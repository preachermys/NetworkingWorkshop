//
//  AppStoryboard.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 20.04.2021.
//

import UIKit

enum AppStoryboard: String {
    
    case main = "Main"
    case loginBMW = "LoginBMW"
    case passwordRecovery = "PasswordRecovery"
    case passwordRecoveryData = "PasswordRecoveryData"
    
    case authWay = "AuthWay"
    case mailPhone = "MailPhone"
    case oneWayAuth = "OneWayAuth"
    case restorePassword = "RestorePassword"
    case enterCode = "EnterCode"
    case newPassword = "NewPassword"
    case companyCode = "CompanyCode"
    
    case videoPlayer = "VideoPlayer"
    case requestDemo = "RequestDemo"
    case requestInformation = "RequestInformation"
    case requestAccess = "RequestAccess"
    
    case `case` = "Case"
    case caseResult = "CaseResult"
    
    case globalControllers = "GlobalControllers"
    
    case removedCard = "RemovedCard"
    
    case longread = "Longread"
    case feed = "Feed"
    case audio = "Audio"
    case video = "Video"
    case photo = "Photo"
    case survey = "Survey"
    case openQuestion = "OpenQuestion"
    case photoTags = "PhotoTags"
    case timeline = "Timeline"
    case timelineDetail = "TimelineDetail"
    
    case test = "Test"
    case testResult = "TestResult"
    
    case congratulation = "Congratulation"
    
    case profile = "Profile"
    case favorites = "Favorites"
    
    case tasks = "Tasks"
    
    case devices = "Devices"
    
    case filters = "Filters"
    
    case comment = "Comment"
    case comments = "Comments"
    
    case duel = "Duel"
    case duelsList = "DuelsList"
    case duelsStatistics = "DuelStatistics"
    case activeDuels = "ActiveDuels"
    case duelCover = "DuelCover"
    case testQuestions = "TestQuestions"
    
    case trainingCardsList = "TrainingCardsList"
    case trainingsList = "TrainingsList"
    case trainingMain = "TrainingMain"
    case trainingsCategory = "TrainingsCategory"
    case categoriesList = "CategoriesList"
    
    case excessSessions = "ExcessSessions"
    case sessionCode = "SessionCode"
    case sessionsSuccess = "SessionsSuccess"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiateFrom(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
