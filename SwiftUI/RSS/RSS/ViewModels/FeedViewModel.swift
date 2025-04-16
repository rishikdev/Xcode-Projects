//
//  FeedViewModel.swift
//  RSS
//
//  Created by Rishik Dev on 10/01/2025.
//

import Foundation
import SwiftUI

struct GroupedFeedItem: Identifiable {
    let id: UUID = UUID()
    let date: String
    var items: [FeedItemModel]
}

@MainActor
class FeedViewModel: ObservableObject {
    @AppStorage("lastFetched") private var lastFetched: String = ""
    @Published var groupedFeedItems: [GroupedFeedItem] = []
    @Published var groupedBookmarkedFeedItems: [GroupedFeedItem] = []
    @Published var fetchStatus: FetchStatus = .uninitiated
    @Published var feedItemCoreDataTransactionStatus: CoreDataTransactionStatus = .uninitiated
    @Published var errorMessage: String = ""
    @Published var currentOutletName: String = ""
    @Published var currentOperationName: String = ""
    
    private var operationPerformed: Bool = false
    private var partialFailure: Bool = false
    private var feedItemModels: [FeedItemModel] = []
    private var newFeedItemModels: [FeedItemModel] = []
    private var failedRemoteOutletsNames: [String] = []
    
    var failedOperations: [OperationsEnum] = []
    let coreDataManager: CoreDataManagerProtocol
    let feedParser: FeedParser
    let networkManager: NetworkManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol, feedParser: FeedParser, networkManager: NetworkManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.feedParser = feedParser
        self.networkManager = networkManager
    }
    
    func fetchFeedItems(for outlets: [OutletModel], on device: DeviceType = .nonPreview) async {
        self.groupedFeedItems.removeAll()
        self.groupedBookmarkedFeedItems.removeAll()
        self.fetchStatus = .loading
        self.errorMessage = ""
        self.operationPerformed = false
        self.partialFailure = false
        self.feedItemModels.removeAll()
        self.newFeedItemModels.removeAll()
        self.failedRemoteOutletsNames.removeAll()
        self.failedOperations.removeAll()
        
        fetchLocalFeedItems(outlets)

        for outlet in outlets {
            if (outlet.isEnabled) {
                self.operationPerformed = true
                
                let data = await fetchRemoteFeedItems(for: outlet, on: device)
                
                if let data {
                    let parsedFeedItems = parseRemoteFeedItems(data: data, outlet: outlet)
                    
                    if let parsedFeedItems {
                        self.newFeedItemModels = separateNewFeedItems(in: parsedFeedItems)
                        self.feedItemModels.append(contentsOf: newFeedItemModels)
                        
                        for newFeedItemModel in newFeedItemModels {
                            saveFeedItem(newFeedItemModel)
                        }
                    }
                }
            }
        }

        if (operationPerformed) {
            groupAndSortItems()
            filterBookmarkedFeedItems()
            lastFetched = Date.now.formatted(date: .complete, time: .shortened)
        }
        
        if (!outlets.isEmpty && operationPerformed && groupedFeedItems.isEmpty) {
            self.errorMessage = "Could not fetch any data. Please try again later."
            self.fetchStatus = .failure
        } else if (partialFailure) {
            self.errorMessage = "Some operations could not be completed. Please try again later."
            self.fetchStatus = .partialFailure
            
        } else {
            self.fetchStatus = self.operationPerformed ? .success : .uninitiated
        }

        self.feedItemModels.removeAll()
        self.newFeedItemModels.removeAll()
    }
    
    func deleteFeedItems(for outlet: OutletModel) {
        do {
            self.feedItemCoreDataTransactionStatus = .loading
            try coreDataManager.deleteFeedItems(for: outlet)
            
            var updatedGroupedFeedItems: [GroupedFeedItem] = []
            
            for groupedFeedItem in self.groupedFeedItems {
                for feedItemModel in groupedFeedItem.items {
                    if feedItemModel.outlet.id != outlet.id {
                        updatedGroupedFeedItems.append(groupedFeedItem)
                    }
                }
            }
            
            self.groupedFeedItems = updatedGroupedFeedItems
            self.feedItemCoreDataTransactionStatus = .success
            
        } catch {
            self.feedItemCoreDataTransactionStatus = .failure
            print("Error deleting feed items: \(error)")
        }
    }
    
    func toggleIsBookmarked(_ feedItemModelToUpdate: FeedItemModel) {
        do {
            self.currentOperationName = "Toggling"
            self.currentOutletName = feedItemModelToUpdate.title
            self.feedItemCoreDataTransactionStatus = .loading
            
            var isToggled: Bool = false
            
            try coreDataManager.updateFeedItem(feedItemModelToUpdate)
                        
            for (groupedFeedItemsIndex, groupedFeedItem) in self.groupedFeedItems.enumerated() {
                for (feedItemModelIndex, feedItemModel) in groupedFeedItem.items.enumerated() {
                    if (feedItemModel.id == feedItemModelToUpdate.id) {
                        isToggled = true
                        var updatedItem = self.groupedFeedItems[groupedFeedItemsIndex].items[feedItemModelIndex]
                        updatedItem.isBookmarked.toggle()
                        self.groupedFeedItems[groupedFeedItemsIndex].items[feedItemModelIndex] = updatedItem
                        break
                    }
                }
                
                if (isToggled) {
                    break
                }
            }

            filterBookmarkedFeedItems()
            
            self.feedItemCoreDataTransactionStatus = .success
            
        } catch {
            self.feedItemCoreDataTransactionStatus = .failure
            print("Error updating feed item: \(error)")
        }
    }
    
    func filterBookmarkedFeedItems() {
        self.currentOperationName = "Filtering"
        self.currentOutletName = "Feed Items"
        self.fetchStatus = .loading

        self.groupedBookmarkedFeedItems = self.groupedFeedItems
        var newGroupedBookmarkedFeedItems: [GroupedFeedItem] = []
                
        for groupedBookmarkedFeedItem in groupedBookmarkedFeedItems {
            var feedItems: [FeedItemModel] = []
            
            for feedItemModel in groupedBookmarkedFeedItem.items {
                if (feedItemModel.isBookmarked) {
                    feedItems.append(feedItemModel)
                }
            }
            
            if (!feedItems.isEmpty) {
                newGroupedBookmarkedFeedItems.append(GroupedFeedItem(date: groupedBookmarkedFeedItem.date, items: feedItems))
            }
        }
        
        self.groupedBookmarkedFeedItems = newGroupedBookmarkedFeedItems
        
        self.fetchStatus = .success
    }
    
    private func fetchLocalFeedItems(_ outlets: [OutletModel]) {
        do {
            self.currentOperationName = "Fetching"
            self.currentOutletName = "Local Storage"
            self.feedItemCoreDataTransactionStatus = .loading
            
            let fetchedFeedItems = try coreDataManager.fetchFeedItems()
            
            for item in fetchedFeedItems {
                if let itemId = item.id,
                   let title = item.title,
                   let description = item.body,
                   let pubDate = item.pubDate,
                   let link = item.link,
                   let outletEntity = item.outlet,
                   outletEntity.isEnabled {
                    
                    if let id = outletEntity.id,
                       let name = outletEntity.name,
                       let rssUrl = outletEntity.rssUrl,
                       let tag = outletEntity.tag {
                        
                        let outlet = OutletModel(id: id, name: name, rssUrl: rssUrl, tag: tag, isEnabled: outletEntity.isEnabled, feedItemsCount: outletEntity.feedItems?.count ?? 0)
                        let localFeedItem = FeedItemModel(id: itemId, title: title, description: description, pubDate: "\(pubDate)", link: link, isBookmarked: item.isBookmarked, outlet: outlet)
                        
                        self.operationPerformed = true
                        self.feedItemModels.append(localFeedItem)
                    }
                }
            }
            
            self.feedItemCoreDataTransactionStatus = .success
            
        } catch {
            self.failedRemoteOutletsNames.append(currentOutletName)
            self.feedItemCoreDataTransactionStatus = .failure
            self.failedOperations.append(.fetchLocal(value: "Could not fetch data from \(currentOutletName). Please try restarting the application."))
            self.partialFailure = true
            print("Error fetching local feed items: \(error)")
        }
    }
    
    private func fetchRemoteFeedItems(for outlet: OutletModel, on device: DeviceType = .nonPreview) async -> Data? {
        do {
            self.currentOperationName = "Fetching"
            self.currentOutletName = outlet.name
            var data: Data!

            switch device {
            case .preview:
                data = try await networkManager.fetchMockFeedItems(from: outlet.rssUrl)
            case .nonPreview:
                data = try await networkManager.fetchFeedItems(from: outlet.rssUrl)
            }
                        
            return data
            
        } catch let error as RSSError {
            self.failedRemoteOutletsNames.append(currentOutletName)
            self.failedOperations.append(.fetchRemote(value: "Could not fetch data from \(currentOutletName). Please make sure that the RSS Feed URL is correct, or that \(currentOutletName) is operational."))
            self.partialFailure = true
            print("RSSError fetching remote feed items: \(error)")
            
            return nil
        } catch {
            self.failedRemoteOutletsNames.append(currentOutletName)
            self.failedOperations.append(.fetchRemote(value: "Could not fetch data from \(currentOutletName). Please make sure that the RSS Feed URL is correct, or that \(currentOutletName) is operational."))
            self.partialFailure = true
            print("Error fetching remote feed items: \(error)")
            
            return nil
        }
    }
    
    private func parseRemoteFeedItems(data: Data, outlet: OutletModel) -> [FeedItemModel]? {
        do {
            self.currentOperationName = "Parsing"
            self.currentOutletName = outlet.name
            
            return try feedParser.parseFeed(from: data, for: outlet)
            
        } catch let error as RSSError {
            self.failedRemoteOutletsNames.append(currentOutletName)
            self.failedOperations.append(.parse(value: "Could not parse data fetched from \(currentOutletName)."))
            self.partialFailure = true
            print("RSSError parsing remote feed items: \(error)")
            
            return nil
        } catch {
            self.failedRemoteOutletsNames.append(currentOutletName)
            self.failedOperations.append(.parse(value: "Could not parse data fetched from \(currentOutletName)."))
            self.partialFailure = true
            print("Error parsing remote feed items: \(error)")
            
            return nil
        }
    }
    
    private func separateNewFeedItems(in parsedItems: [FeedItemModel]) -> [FeedItemModel] {
        var newParsedItems: [FeedItemModel] = []
        
        for var parsedItem in parsedItems {
            if ((self.feedItemModels.first { $0.link == parsedItem.link }) == nil) {
                parsedItem.isNew = true
                newParsedItems.append(parsedItem)
            }
        }
        
        return newParsedItems
    }
    
    private func saveFeedItem(_ newFeedItemModel: FeedItemModel) {
        do {
            self.feedItemCoreDataTransactionStatus = .loading
            self.currentOperationName = "Saving"
            self.currentOutletName = "Data"
            
            self.operationPerformed = true
            try coreDataManager.addFeedItem(newFeedItemModel, to: newFeedItemModel.outlet)
            let _ = try coreDataManager.fetchFeedItems()
            self.feedItemCoreDataTransactionStatus = .success
        } catch {
            self.feedItemCoreDataTransactionStatus = .failure
            self.failedOperations.append(.save(value: "Could not save \(newFeedItemModel.title) to Local Storage. Please try relaunching the application."))
            self.partialFailure = true
            print("Error saving feed items: \(error)")
        }
    }
    
    private func groupAndSortItems() {
        self.currentOperationName = "Sorting"
        self.currentOutletName = "Data"
        self.groupedFeedItems = sortFeedItemsByDate(groupFeedItemModelsByDate(feedItemModels))
    }
    
    private func groupFeedItemModelsByDate(_ items: [FeedItemModel]) -> [GroupedFeedItem] {
        let groupedItems = Dictionary(grouping: items, by: { $0.pubDate.rfc822ToLocalDateString() })
        var feedItems: [GroupedFeedItem] = []
        
        for var item in groupedItems {
            item.value.sort { $0.pubDate.rfc822ToLocalDateTime() ?? Date() > $1.pubDate.rfc822ToLocalDateTime() ?? Date() }
            let feedItem = GroupedFeedItem(date: item.key, items: item.value)
            feedItems.append(feedItem)
        }
        
        return feedItems
    }
    
    private func sortFeedItemsByDate(_ items: [GroupedFeedItem]) -> [GroupedFeedItem] {
        items.sorted { $0.date.rfc822DateToLocalDate() ?? Date() > $1.date.rfc822DateToLocalDate() ?? Date() }
    }
}
