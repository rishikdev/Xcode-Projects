//
//  HomeView.swift
//  RSS
//
//  Created by Rishik Dev on 10/01/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var feedViewModel: FeedViewModel
    @EnvironmentObject private var outletViewModel: OutletViewModel
    
    @State private var showAlert: Bool = false
    @State private var showOutletsSheet: Bool = false
    @State private var showBookmarkedFeedItemsOnly: Bool = false
    @State private var showErrorsListView: Bool = false
    var device: DeviceType = .nonPreview
    
    var body: some View {
        NavigationStack {
            VStack {
                switch feedViewModel.fetchStatus {
                case .uninitiated:
                    InformationView(primaryText: "Nothing to show")
                    
                case .loading:
                    LoadingView(primaryText: feedViewModel.currentOperationName,
                                secondaryText: feedViewModel.currentOutletName)
                    
                case .success, .partialFailure:
                    FeedView(feedItems: showBookmarkedFeedItemsOnly ? $feedViewModel.groupedBookmarkedFeedItems : $feedViewModel.groupedFeedItems)
                    .environmentObject(feedViewModel)
                    .environmentObject(outletViewModel)
                    .refreshable {
                        fetchRSSItems()
                    }
                    
                case .failure:
                    InformationView(primaryText: "Something went wrong",
                                    primaryTextForegroundColor: .red)
                }
            }
            .alert("Oh no!",
                   isPresented: $showAlert) {
                Button("Dismiss", role: .cancel) { }
                
                Button("See Details") {
                    self.showErrorsListView.toggle()
                }
            } message: {
                Text(feedViewModel.errorMessage)
            }
            .sheet(isPresented: $showOutletsSheet, onDismiss: {
                fetchRSSItems()
            }) {
                OutletsView()
                    .environmentObject(outletViewModel)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    refreshButtonView
                }
                
                ToolbarItemGroup(placement: .confirmationAction) {
                    bookmarkToggleView
                    outletsButtonView
                }
                
                ToolbarItem(placement: .bottomBar) {
                    BottomBarView(showErrorsListSheet: $showErrorsListView)
                        .environmentObject(feedViewModel)
                        .environmentObject(outletViewModel)
                }
            }
            .onAppear {
                deleteInvalidOutlets()
                fetchRSSItems()
            }
            .onChange(of: feedViewModel.fetchStatus) { fetchStatus in
                self.showAlert = (fetchStatus == .failure || fetchStatus == .partialFailure)
            }
            .onChange(of: showBookmarkedFeedItemsOnly) { show in
                if (show) {
                    feedViewModel.filterBookmarkedFeedItems()
                }
            }
            .navigationTitle(Constant.applicationName.rawValue)
        }
    }
    
    // MARK: - refreshButtonView
    private var refreshButtonView: some View {
        CircularButtonView(text: "Refresh", systemImage: "arrow.clockwise") {
            fetchRSSItems()
        }
        .disabled(feedViewModel.fetchStatus == .loading)
    }
    
    // MARK: - bookmarkToggleView
    private var bookmarkToggleView: some View {
        CircularButtonView(text: showBookmarkedFeedItemsOnly ? "View all feed items" : "View bookmarked feed items only",
                           systemImage: showBookmarkedFeedItemsOnly ? "bookmark.fill" : "bookmark",
                           tint: showBookmarkedFeedItemsOnly ? .green : .red) {
            showBookmarkedFeedItemsOnly.toggle()
        }
        .disabled(feedViewModel.fetchStatus == .loading)
    }
    
    // MARK: - outletsButtonView
    private var outletsButtonView: some View {
        CircularButtonView(text: "Outlets", systemImage: "list.bullet") {
            showOutletsSheet.toggle()
        }
        .disabled(feedViewModel.fetchStatus == .loading)
    }
    
    // MARK: - deleteInvalidOutlets()
    private func deleteInvalidOutlets() {
        for outlet in outletViewModel.outlets {
            if (outlet.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                outlet.rssUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                withAnimation {
                    outletViewModel.deleteOutlet(outlet)
                }
            }
        }
    }
    
    // MARK: - fetchRSSItems()
    private func fetchRSSItems() {
        Task {
            await feedViewModel.fetchFeedItems(for: outletViewModel.outlets, on: device)
        }
    }
}

#Preview {
    HomeView(device: .preview)
        .environmentObject(FeedViewModel(coreDataManager: CoreDataManager.shared,
                                         feedParser: FeedParser.shared,
                                         networkManager: NetworkManager.shared))
        .environmentObject(OutletViewModel(coreDataManager: CoreDataManager.shared))
}
