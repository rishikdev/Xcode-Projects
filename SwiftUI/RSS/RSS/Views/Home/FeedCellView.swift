//
//  FeedCellView.swift
//  RSS
//
//  Created by Rishik Dev on 10/01/2025.
//

import SwiftUI

struct FeedCellView: View {
    @Environment(\.colorScheme) private var colourScheme
    
    let item: FeedItemModel
    
    var body: some View {
        HStack {
            RectangularTagView(text: item.outlet.name,
                               colour: item.outlet.tag.toColour())
            .padding(-4)
            
            VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                        .fontWeight(.bold)
                
                Text(item.description.removingHTML())
                    .font(.subheadline)
                    .lineLimit(3)
                
                Spacer()
                
                Text(item.pubDate.rfc822ToTimeString())
                    .textCase(.uppercase)
                    .font(.caption)
                    .fontWeight(.light)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(5)
                        
            ZStack(alignment: .top) {
                if (item.isNew) {
                    RectangularTagView(text: "NEW",
                                       colour: colourScheme == .dark ? "white".toColour() : "black".toColour(),
                                       textColour: colourScheme == .dark ? "black".toColour() : "white".toColour(),
                                       brightness: 0,
                                       rotationAngle: 90
                    )
                }
                
                if (item.isBookmarked) {
                    Image(systemName: "bookmark.fill")
                        .imageScale(.medium)
                        .foregroundStyle(colourScheme == .dark ?
                                         (item.isNew ? .black : .white) :
                                            (item.isNew ? .white : .black))
                        .frame(maxHeight: .infinity, alignment: .top)
                        .offset(y: 15)
                        .padding(-4)
                }
            }
            .frame(maxHeight: .infinity)
            .padding(-4)
        }
    }
}

#Preview {
    FeedCellView(item: FeedItemModel(isNew: false,
                                     title: "Good News!",
                                     description: "The Dacia Sandero is coming soon! We have some confirmation about its arrival in the UK... Alright, James, I don't think anyone here is interested in UK's cheapest car. But, I'm sure you'll be interested in this one!",
                                     pubDate: "Sat, 16 Jul 2022 20:48:52 -0600",
                                     link: "www.link.com",
                                     isBookmarked: false,
                                     outlet: OutletModel(id: UUID(), name: "BBC News")))
    .frame(height: 100)
    .padding()
}
