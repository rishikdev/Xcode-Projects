//
//  OutletViewModel.swift
//  RSS
//
//  Created by Rishik Dev on 14/02/2025.
//

import Foundation

@MainActor
class OutletViewModel: ObservableObject {
    @Published var outlets: [OutletModel] = []
    @Published var outletCoreDataTransactionStatus: CoreDataTransactionStatus = .uninitiated
    @Published var errorMessage: String = ""
    
    let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
        loadPersistentStores()
    }
    
    private func loadPersistentStores() {
        do {
            self.outletCoreDataTransactionStatus = .loading
            try coreDataManager.loadPersistentStores()
            fetchOutlets()
        } catch {
            self.outletCoreDataTransactionStatus = .failure
            self.errorMessage = "Could not load persistent store. Please try again later."
            print("Error loading persistent stores: \(error)")
        }
    }
    
    func fetchOutlets() {
        do {
            self.outletCoreDataTransactionStatus = .loading
            self.outlets.removeAll()
            self.errorMessage = ""
            let fetchedOutlets = try coreDataManager.fetchOutlets()
            var unpublishedOutlets: [OutletModel] = []
            
            for fetchedOutlet in fetchedOutlets {
                if let id = fetchedOutlet.id,
                   let name = fetchedOutlet.name,
                   let rssUrl = fetchedOutlet.rssUrl,
                   let tag = fetchedOutlet.tag,
                   let feedItems = fetchedOutlet.feedItems?.allObjects as? [FeedItemEntity]
                {
                    let outlet = OutletModel(id: id, name: name, rssUrl: rssUrl, tag: tag, isEnabled: fetchedOutlet.isEnabled, feedItemsCount: feedItems.count)
                    unpublishedOutlets.append(outlet)
                }
            }
            self.outlets = unpublishedOutlets
            self.outletCoreDataTransactionStatus = .success
        } catch {
            self.outletCoreDataTransactionStatus = .failure
            self.errorMessage = "Could not fetch outlets. Please try again later."
            print("Error fetching outlets: \(error)")
        }
    }
    
    func addOutlet(_ outlet: OutletModel) {
        do {
            self.outletCoreDataTransactionStatus = .loading
            self.errorMessage = ""
            try coreDataManager.addOutlet(outlet)
            self.fetchOutlets()
            self.outletCoreDataTransactionStatus = .success
        } catch {
            self.outletCoreDataTransactionStatus = .failure
            self.errorMessage = "Could not add \(outlet.name). Please try again later."
            print("Error saving outlet: \(error)")
        }
    }
    
    func updateOutlet(_ outlet: OutletModel) {
        do {
            self.outletCoreDataTransactionStatus = .loading
            self.errorMessage = ""
            try coreDataManager.updateOutlet(outlet)
            self.fetchOutlets()
            self.outletCoreDataTransactionStatus = .success
        } catch {
            self.outletCoreDataTransactionStatus = .failure
            self.errorMessage = "Could not update \(outlet.name). Please try again later."
            print("Error updating outlet: \(error)")
        }
    }
    
    func deleteOutlet(_ outlet: OutletModel) {
        do {
            self.outletCoreDataTransactionStatus = .loading
            self.errorMessage = ""
            try coreDataManager.deleteOutlet(outlet)
            self.fetchOutlets()
            self.outletCoreDataTransactionStatus = .success
        } catch {
            self.outletCoreDataTransactionStatus = .failure
            self.errorMessage = "Could not delete \(outlet.name). Please try again later."
            print("Error deleting outlet: \(error)")
        }
    }
}
