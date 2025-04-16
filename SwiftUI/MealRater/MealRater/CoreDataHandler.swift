//
//  CoreDataHandler.swift
//  MealRater
//
//  Created by Rishik Dev on 11/11/24.
//

import Foundation
import CoreData

class CoreDataHandler {
    private init() { }
    
    static let shared = CoreDataHandler()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Ratings")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Persistent container failure: \(error)")
            }
        })
        return container
    }()
    
    func getContext() -> NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext (context: NSManagedObjectContext) {
        if(context.hasChanges) {
            do {
                try context.save()
                let _ = fetchData()
            } catch {
                fatalError("FAILED TO SAVE CONTEXT: \(error)")
            }
        }
    }
    
    func fetchData() -> [Ratings] {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Ratings> = Ratings.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError("FETCHING RATINGS FAILED \(error)")
        }
        
    }
    
    func saveData(ratingModel: RatingModel) {
        let context = getContext()
        let ratingsEntity = Ratings(context: context)
        
        ratingsEntity.id = ratingModel.id
        ratingsEntity.restaurantName = ratingModel.restaurantName
        ratingsEntity.dishName = ratingModel.dishName
        ratingsEntity.dishRating = ratingModel.dishRating
        
        saveContext(context: context)
    }
    
    func deleteRating(ratingModel: RatingModel) {
        let context = getContext()
        let ratingsEntity = fetchData()
        
        guard let ratingToDelete = ratingsEntity.first(where: { $0.id == ratingModel.id }) else { return }
        
        persistentContainer.viewContext.delete(ratingToDelete)
        
        saveContext(context: context)
    }
}
