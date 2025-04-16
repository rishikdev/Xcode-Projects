//
//  FeedView.swift
//  RSS
//
//  Created by Rishik Dev on 25/02/2025.
//

import SwiftUI

struct FeedView: View {
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var feedViewModel: FeedViewModel
    @EnvironmentObject private var outletViewModel: OutletViewModel
    
    @Binding var feedItems: [GroupedFeedItem]
    
    var body: some View {
        VStack {
            if (feedItems.isEmpty) {
                InformationView(primaryText: "Nothing to show")
            } else {
                List {
                    ForEach($feedItems) { $feedItem in
                        Section(header: Text(feedItem.date).font(.title)) {
                            ForEach($feedItem.items) { $item in
                                FeedCellView(item: item)
                                    .onTapGesture {
                                        openURL(URL(string: item.link.trimmingCharacters(in: .whitespacesAndNewlines))!)
                                    }
                                    .contextMenu {
                                        Button {
                                            UIPasteboard.general.string = item.link.trimmingCharacters(in: .whitespacesAndNewlines)
                                        } label: {
                                            // Not using `systemImage` as `document.on.document`
                                            // is only available on devices running iOS 18 and above
                                            Label("Copy Link", image: "document.on.document")
                                        }
                                        
                                        Button {
                                            openURL(URL(string: item.link.trimmingCharacters(in: .whitespacesAndNewlines))!)
                                        } label: {
                                            Label("Open Link", systemImage: "plus.square.on.square")
                                        }
                                        
                                        Button {
                                            withAnimation {
                                                feedViewModel.toggleIsBookmarked(item)
                                            }
                                        } label: {
                                            Label(item.isBookmarked ? "Remove from Bookmarks" : "Add to Bookmarks",
                                                  systemImage: item.isBookmarked ? "bookmark.slash" : "bookmark")
                                        }
                                        
                                        Divider()
                                        
                                        NavigationLink {
                                            OutletDetailsView(outlet: item.outlet, showDeleteActions: true)
                                                .environmentObject(feedViewModel)
                                                .environmentObject(outletViewModel)
                                        } label: {
                                            Label("Edit \(item.outlet.name)", systemImage: "square.and.pencil")
                                        }
                                        
                                        Divider()
                                        
                                        ShareLink(item: URL(string: item.link.trimmingCharacters(in: .whitespacesAndNewlines))!)
                                    }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    let feedItems: [GroupedFeedItem] = [
        GroupedFeedItem(date: "Monday, 16 Sep 2024", items: [
            FeedItemModel(isNew: true,
                          title: "On That Terrible Disappointment",
                          description: "",
                          pubDate: "Mon, 16 Sep 2024 20:00:00 -0600",
                          link: "www.link3.com",
                          isBookmarked: true,
                          outlet: OutletModel(id: UUID(), name: "The Grand Tour", tag: "brown"))
        ]),
        
        GroupedFeedItem(date: "Saturday, 16 Jul 2022", items: [
            FeedItemModel(isNew: true,
                          title: "Good News!",
                          description: "The Dacia Sandero is coming soon! We have some confirmation about its arrival in the UK... Alright, James, I don't think anyone here is interested in UK's cheapest car. But, I'm sure you'll be interested in this one!",
                          pubDate: "Sat, 16 Jul 2022 06:48:52 -0600",
                          link: "www.link1.com",
                          isBookmarked: false,
                          outlet: OutletModel(id: UUID(), name: "BBC News", tag: "blue")),
            
            FeedItemModel(isNew: false,
                          title: "On That Bombshell!",
                          description: "It is time to end. Thank you so much for watching. See you next time! Good night!",
                          pubDate: "Mon, 1 Jun 2015 15:30:00 -0600",
                          link: "www.link2.com",
                          isBookmarked: false,
                          outlet: OutletModel(id: UUID(), name: "Top Gear"))
        ]),
        
        GroupedFeedItem(date: "Monday, 1 Jun 2015", items: [
            FeedItemModel(title: "Bad News!",
                          description: "The Dacia Sandero is not coming anytime soon! But, I'm sure it will come someday!",
                          pubDate: "Sat, 16 Jul 2022 06:48:52 -0600",
                          link: "www.link1.com",
                          isBookmarked: true,
                          outlet: OutletModel(id: UUID(), name: "BBC News", tag: "blue"))
        ]),
    ]
    
    NavigationStack {
        FeedView(feedItems: .constant(feedItems))
        .environmentObject(FeedViewModel(coreDataManager: CoreDataManager.shared,
                                         feedParser: FeedParser.shared,
                                         networkManager: NetworkManager.shared))
        .environmentObject(OutletViewModel(coreDataManager: CoreDataManager.shared))
        .navigationTitle(Constant.applicationName.rawValue)
    }
}
