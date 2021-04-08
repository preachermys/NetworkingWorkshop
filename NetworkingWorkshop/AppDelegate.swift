//
//  AppDelegate.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 23.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var bgSessionCompletionHandler: (() -> ())? // опциональное замыкание в качестве типа
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // в блок completionHandler будет передаваться сообщение с идентификатором сессии, вызывающего запуск приложения
        // при запуске приложения снова создается сессия для фоновой загрузки данных, которая автоматически связывается с текущей фоновой активностью
        // поэтому будем сохранять захваченное значение в только что созданное свойство
        bgSessionCompletionHandler = completionHandler
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
          
//        ApplicationDelegate.shared.application(
//            application,
//            didFinishLaunchingWithOptions: launchOptions
//        )
//
//        FirebaseApp.configure()
//
//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        return true
    }
          
//    func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//
//        // для авторизации через Фейсбук
//        // через Гугл делается посредством изменений в Target -> Info, поэтому этот кусок закомментируем
////        ApplicationDelegate.shared.application(
////            app,
////            open: url,
////            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
////            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
////        )
//        
////        return GIDSignIn.sharedInstance().handle(url) // для Google SDK
//
//    }
}

