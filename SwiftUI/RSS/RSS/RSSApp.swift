//
//  RSSApp.swift
//  RSS
//
//  Created by Rishik Dev on 10/01/2025.
//

import SwiftUI

@main
struct RSSApp: App {
    @StateObject private var feedViewModel: FeedViewModel = .init(coreDataManager: CoreDataManager.shared,
                                                                feedParser: FeedParser.shared,
                                                                networkManager: NetworkManager.shared)
    
    @StateObject private var outletViewModel: OutletViewModel = .init(coreDataManager: CoreDataManager.shared)
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(outletViewModel)
                .environmentObject(feedViewModel)
        }
    }
}
