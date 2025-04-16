//
//  NewsCell.swift
//  DailyDigest
//
//  Created by Rishik Dev on 13/04/23.
//

import SwiftUI

struct NewsCell: View {
    var article: Article
    @Environment(\.colorScheme) var colourScheme
    @State private var publishedDate: String = ""
    @State private var content: String = ""
    
    private let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text(article.title!)
                    .font(.headline)
                
                Divider()
                
                HStack {
                    Text(article.source?.name! ?? "No Source")
                    Spacer()
                    Text(publishedDate)
                }
                .font(.callout)
                .foregroundColor(Color(UIColor.darkGray))
            }
            .padding(5)
            
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: article.urlToImage ?? Constants.URLs.defaultImage.rawValue),
                           content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                }, placeholder: {
                    Image(systemName: "photo.fill")
                        .imageScale(.large)
                })
                
                Text(article.description ?? "No Description")
                    .lineLimit(article.isTapped ? 5 : 2)
                    .fontWeight(article.isTapped ? .semibold : .regular)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                    .padding(5)
                    .background(.ultraThinMaterial)
                
            }
            
            if(article.isTapped) {
                Text(content)
                    .padding(5)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: colourScheme == .light ? .gray : .black, radius: article.isTapped ? 6 : 2)
        .padding()
        .onAppear {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: article.publishedAt ?? "")
            dateFormatter.dateFormat = "E, MMM d, yyyy h:mm a"
            publishedDate = dateFormatter.string(from: date ?? Date())
            
            if let articleContent = article.content {
                content = String(articleContent.prefix(200))
            }
        }
    }
}

struct NewsCell_Previews: PreviewProvider {
    static var previews: some View {
        NewsCell(article: TestData.data.articles![4])
    }
}
