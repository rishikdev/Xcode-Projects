//
//  OutletModel.swift
//  RSS
//
//  Created by Rishik Dev on 15/01/2025.
//

import Foundation
import SwiftUI

struct OutletModel: Identifiable, Hashable {
    var id: UUID
    var name: String
    var rssUrl: String
    var tag: String
    var isEnabled: Bool
    var feedItemsCount: Int
    
    init(id: UUID,
         name: String = "",
         rssUrl: String = "",
         tag: String = "red",
         isEnabled: Bool = true,
         feedItemsCount: Int = 0) {
        
        self.id = id
        self.name = name
        self.rssUrl = rssUrl
        self.tag = tag
        self.isEnabled = isEnabled
        self.feedItemsCount = feedItemsCount
    }
}
