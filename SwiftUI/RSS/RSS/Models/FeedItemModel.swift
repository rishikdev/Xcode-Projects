//
//  FeedItemModel.swift
//  RSS
//
//  Created by Rishik Dev on 10/01/2025.
//

import Foundation

struct FeedItemModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var isNew: Bool = false
    var title: String
    var description: String
    var pubDate: String
    var link: String
    var isBookmarked: Bool = false
    var outlet: OutletModel
}
