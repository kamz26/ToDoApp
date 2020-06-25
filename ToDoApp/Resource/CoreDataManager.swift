//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by Abhisek K. on 24/06/20.
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class CoreDataManager {
    
    
    static let sharedManager = CoreDataManager()
    
    private init() {}
    fileprivate var selfViewContext:NSManagedObjectContext!
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ToDoApp")
        
        selfViewContext = container.viewContext
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    func saveTask(taskData: [String:Any]){
        if selfViewContext == nil{
            selfViewContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        }
        let taskEntity = Task(context: selfViewContext)
        taskEntity.taskTitle = taskData["title"] as? String
        taskEntity.taskDescription = taskData["description"] as? Data
        taskEntity.taskIsSelected = taskData["isSelected"] as? Bool ?? false
        taskEntity.taskId = taskData["taskId"] as? String
        saveContext()
    }
    
    func fetchTask() -> [Task]{
        
        if selfViewContext == nil{
            selfViewContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            
            let result = try selfViewContext.fetch(fetchRequest)
            return result as! [Task]
            
        } catch {
            print("Failed")
        }
        return []
        
    }
    
    
    func updateTask(taskData: [String:Any]){
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "taskId = %@", taskData["taskId"] as! String)
        do
        {
            let test = try selfViewContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(taskData["title"] as! String , forKey: "taskTitle")
            objectUpdate.setValue(taskData["description"] as! Data, forKey: "taskDescription")
            objectUpdate.setValue(taskData["isSelected"] as! Bool, forKey: "taskIsSelected")
            objectUpdate.setValue(taskData["taskId"], forKey: "taskId")
            saveContext()
        }
        catch
        {
            print(error)
        }
        
    }
    
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
