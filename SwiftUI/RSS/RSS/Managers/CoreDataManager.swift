//
//  CoreDataManager.swift
//  RSS
//
//  Created by Rishik Dev on 14/02/2025.
//

import CoreData
import Foundation

protocol CoreDataManagerProtocol {
    func loadPersistentStores() throws
    func fetchOutlets() throws -> [OutletEntity]
    func saveData() throws
    func addOutlet(_ outlet: OutletModel) throws
    func updateOutlet(_ outlet: OutletModel) throws
    func deleteOutlet(_ outlet: OutletModel) throws
    func fetchFeedItems() throws -> [FeedItemEntity]
    func addFeedItem(_ feedItem: FeedItemModel, to outletModel: OutletModel) throws
    func updateFeedItem(_ feedItem: FeedItemModel) throws
    func deleteFeedItems(for outlet: OutletModel) throws
}

class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    private let container = NSPersistentContainer(name: "RSSContainer")
    
    private var outlets: [OutletEntity] = []
    private var feedItems: [FeedItemEntity] = []
    
    private init() { }
    
    func loadPersistentStores() throws {
        var encounteredError: Error?
        
        container.loadPersistentStores { description, error in
            if let error = error {
                encounteredError = error
            }
        }
        
        if let encounteredError = encounteredError {
            throw encounteredError
        }
    }
    
    private func getStoreURL() {
        guard let storeUrl = container.persistentStoreCoordinator.persistentStores.first?.url else {
            print("No Persistent Stores")
            return
        }
        print(storeUrl)
    }
    
    func saveData() throws {
        do {
            try container.viewContext.save()
            self.outlets = try fetchOutlets()
        } catch {
            throw error
        }
    }
    
    // MARK: - OutletEntity Functions
    func fetchOutlets() throws -> [OutletEntity] {
        let request = NSFetchRequest<OutletEntity>(entityName: "OutletEntity")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            self.outlets = try container.viewContext.fetch(request)
            return outlets
        } catch {
            throw error
        }
    }
    
    func addOutlet(_ outlet: OutletModel) throws {
        let newOutlet = OutletEntity(context: container.viewContext)
        newOutlet.id = outlet.id
        newOutlet.name = outlet.name
        newOutlet.rssUrl = outlet.rssUrl
        newOutlet.tag = outlet.tag
        newOutlet.isEnabled = outlet.isEnabled
        newOutlet.feedItems = []
        
        do {
            try saveData()
        } catch {
            throw error
        }
    }
    
    func updateOutlet(_ outlet: OutletModel) throws {
        if let outletToUpdate = outlets.first(where: { $0.id == outlet.id }) {
            outletToUpdate.name = outlet.name
            outletToUpdate.rssUrl = outlet.rssUrl
            outletToUpdate.tag = outlet.tag
            outletToUpdate.isEnabled = outlet.isEnabled
            
            do {
                try saveData()
            } catch {
                throw error
            }
        }
    }
    
    func deleteOutlet(_ outlet: OutletModel) throws {
        if let outletToDelete = outlets.first(where: { $0.id == outlet.id }) {
            container.viewContext.delete(outletToDelete)

            do {
                try saveData()
            } catch {
                throw error
            }
        }
    }
    
    // MARK: - FeedItemEntity Functions
    func fetchFeedItems() throws -> [FeedItemEntity] {
        let request = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
        
        do {
            self.feedItems = try container.viewContext.fetch(request)
            return feedItems
        } catch {
            throw error
        }
    }
    
    func addFeedItem(_ feedItem: FeedItemModel, to outletModel: OutletModel) throws {
        let outletToAddTo = outlets.first { $0.id == outletModel.id }
        let newFeedItem = FeedItemEntity(context: container.viewContext)

        newFeedItem.id = feedItem.id
        newFeedItem.title = feedItem.title
        newFeedItem.body = feedItem.description
        newFeedItem.pubDate = feedItem.pubDate
        newFeedItem.link = feedItem.link
        newFeedItem.isBookmarked = feedItem.isBookmarked
        newFeedItem.outlet = outletToAddTo
        
        outletToAddTo?.addToFeedItems(newFeedItem)
        
        do {
            try saveData()
        } catch {
            throw error
        }
    }
    
    func updateFeedItem(_ feedItem: FeedItemModel) throws {
        if let feedItemToUpdate = feedItems.first(where: { $0.id == feedItem.id }) {
            feedItemToUpdate.isBookmarked.toggle()
            
            do {
                try saveData()
            } catch {
                throw error
            }
        }
    }
    
    func deleteFeedItems(for outlet: OutletModel) throws {
        if let outletToModify = outlets.first(where: { $0.id == outlet.id }) {
            if let feedItemsToDelete = outletToModify.feedItems?.allObjects as? [FeedItemEntity] {
                for feedItemToDelete in feedItemsToDelete {
                    container.viewContext.delete(feedItemToDelete)
                }
            }
            
            do {
                try saveData()
            } catch {
                throw error
            }
        }
    }
}
