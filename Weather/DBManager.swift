//
//  DBManager.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/10/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit
import CoreData

class DBManager: NSObject {
    
    static let manager = DBManager()

    
    func locationFetchedResultController(with query: String?)->NSFetchedResultsController<Location>{
        
        //configure query
        let request : NSFetchRequest<Location> = Location.fetchRequest()
        if let query = query, !query.isEmpty{
            
            request.predicate = NSPredicate(format: "city CONTAINS[cd] %@", query,query)
        }
        
        let city = NSSortDescriptor(key: "city", ascending: true)
        let state = NSSortDescriptor(key: "state", ascending: true)
        
        request.sortDescriptors = [state, city]
        
        //create controller
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        //fetch data from sqlite
        do{
            try controller.performFetch()
          
        }catch{
            print(error)
        }
        return controller
        
    }
    
    
    func favoriteLocationFetchedResultController()->NSFetchedResultsController<FavoriteLocations>{
        
        //configure query
        let request : NSFetchRequest<FavoriteLocations> = FavoriteLocations.fetchRequest()
       
        let insertTime = NSSortDescriptor(key: "insertTime", ascending: false)
        
        
        request.sortDescriptors = [insertTime]
        
        //create controller
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        //fetch data from sqlite
        do{
            try controller.performFetch()
            
        }catch{
            print(error)
        }
        return controller
    }



    
    
    func fetchFavoriteLocations()->[FavoriteLocations]{
        
        //configure query
        let request : NSFetchRequest<FavoriteLocations> = FavoriteLocations.fetchRequest()
        
        let insertTime = NSSortDescriptor(key: "insertTime", ascending: false)
        
        request.sortDescriptors = [insertTime]
        
        //fetch
        let result = try? persistentContainer.viewContext.fetch(request)
        return result ?? []
        
        
        
    }
    func lastReasearch()->[LastReasearch]{
        //configure query
        let request : NSFetchRequest<LastReasearch> = LastReasearch.fetchRequest()
        
        let time = NSSortDescriptor(key: "time", ascending: false)
        
        
        request.sortDescriptors = [time]
        
        //fetch
        let result = try? persistentContainer.viewContext.fetch(request)
        return result ?? []

    }
    
    
    
    func deletelastSearch(last: LastReasearch){
        //configure query
  
        
        
                persistentContainer.viewContext.delete(last)
                persistentContainer.viewContext.refreshAllObjects()
                
        
                do {
                    try persistentContainer.viewContext.save()
                    print("saved!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
                
            }
    

    
    
    
    func deleteFavorite(favorite: FavoriteLocations){
        //configure query
        let request : NSFetchRequest<FavoriteLocations> = FavoriteLocations.fetchRequest()
        
        let result = try? persistentContainer.viewContext.fetch(request)
        let resultData = result!
        for object in resultData {
            if object == favorite{
            persistentContainer.viewContext.delete(object)
                persistentContainer.viewContext.refreshAllObjects()
                
                print(object == favorite)
                do {
                    try persistentContainer.viewContext.save()
                    print("saved!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
                
        }
        }
    }
 
    
    
    
    // MARK: Delete Data Records
    
    func deleteRecords() -> Void {
      let request : NSFetchRequest<LastReasearch> = LastReasearch.fetchRequest()
        
       let result = try? persistentContainer.viewContext.fetch(request)
        let resultData = result!
        
        for object in resultData {
           
            persistentContainer.viewContext.delete(object)
                 persistentContainer.viewContext.refreshAllObjects()
            try? persistentContainer.viewContext.save()
      
        }
        do {
            try persistentContainer.viewContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }

    
    // MARK: - Core Data stack
    var context : NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        

        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
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
