//
//  CoreDataService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import CoreData

enum CoreDataObjectFabric {
    
//    static func createNotificationObject(from data: [String: Any]) -> NotificationEntity {
//        let entityDescription = NSEntityDescription.entity(forEntityName: "NotificationEntity", in: (NotificationService.shared.privateMOC))
//        let managedObject = NotificationEntity.init(entity: entityDescription!, insertInto: NotificationService.shared.privateMOC)
//        managedObject.updateFromDict(dict: data)
//
//        return managedObject
//    }
    
    static func createCardlessTasksObject(from data: [String: Any]) -> CardlessTasksEntity {
        let context = TasksService.shared.privateMOC
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CardlessTasksEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        _ = try? context.execute(deleteRequest)
                
        let entityDescription = NSEntityDescription.entity(forEntityName: "CardlessTasksEntity", in: TasksService.shared.privateMOC)
        let managedObject = CardlessTasksEntity.init(entity: entityDescription!, insertInto: TasksService.shared.privateMOC)
        managedObject.updateFromDict(dict: data)
        
        return managedObject
    }
    
    static func createTasksObjectsArray(from data: [[String: Any]]) -> [TaskEntity] {
        var tasks: [TaskEntity] = []
        
        data.forEach({ task in
            guard let id = task["id"] as? String else {
                return
            }
            let managedObject = TaskEntity.createOrReuseEntity(id: id)
            //managedObject.updateFromDict(dict: task)
            tasks.append(managedObject)
        })

        return tasks
    }
    
    static func createTaskObject(from data: [String: Any]) -> TaskEntity {
        let context = TasksService.shared.privateMOC
        let entityDescription = NSEntityDescription.entity(forEntityName: "TaskEntity", in: context)
        let managedObject = TaskEntity.init(entity: entityDescription!, insertInto: context)
        //managedObject.updateFromDict(dict: data)
        
        return managedObject
    }
    
    static func createDuelEntity(from data: [String: Any]) -> DuelEntity {
        let managedObject = DuelEntity.createOrReuseEntity(id: (data["id"] as? String)!)
        managedObject.updateFromDict(dictionary: data)
        return managedObject
    }
    
    static func deleteDuels(with dataList: [[String: Any]]) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DuelEntity")
        if let results = try? DuelsService.shared.privateMOC.fetch(fetchRequest) {
            guard let results = results as? [DuelEntity] else { return }
            for result in results {
                if !dataList.first(where: { (data) -> Bool in
                    (data["id"] as? String)! == result.id
                }).isNil { continue }
                DuelsService.shared.privateMOC.delete(result)
            }
        }
    }
    
    static func createTrainingCategoryEntity(from data: [String: Any]) -> TrainingCategoryEntity {
        let entityDescription = NSEntityDescription.entity(forEntityName: "TrainingCategoryEntity",
                                                           in: TrainingService.shared.privateMOC)
        let managedObject = TrainingCategoryEntity.init(entity: entityDescription!,
                                                        insertInto: TrainingService.shared.privateMOC)
        managedObject.updateFromDict(dict: data)

        return managedObject
    }
    
    static func createTrainingEntity(from data: [String: Any]) -> TrainingEntity {
        let entityDescription = NSEntityDescription.entity(forEntityName: "TrainingEntity",
                                                           in: TrainingService.shared.privateMOC)
        
        let managedObject = TrainingEntity.init(entity: entityDescription!,
                                                insertInto: TrainingService.shared.privateMOC)
        managedObject.updateFromDict(dict: data, special: nil)
        
        return managedObject
    }
}

extension Optional {
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
}
