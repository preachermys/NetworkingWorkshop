//
//  CoreDataStack.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    private init() { }
    
    func createPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!
        let storeURL = documentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        
        let modelURL = Bundle.main.url(forResource: "db", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil, at: storeURL, options: options)
        } catch {
            NSLog("Failed to initialize MyApp core data")
            abort()
        }
        
        return coordinator
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.createPersistentStoreCoordinator()
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
}
