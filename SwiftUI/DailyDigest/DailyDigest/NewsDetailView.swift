//
//  NewsDetailView.swift
//  DailyDigest
//
//  Created by Rishik Dev on 13/04/23.
//

import SwiftUI

struct NewsDetailView: View {
    var article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: article.urlToImage ?? Constants.URLs.defaultImage.rawValue),
                       content: { image in
                image
                    .resizable()
                    .scaledToFit()
                    
            }, placeholder: {
                Image(systemName: "photo.fill")
            })
            .ignoresSafeArea()
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(article.title ?? "No Title")
                    .font(.title)
                
                VStack(alignment: .leading) {
                    Text("Source: \(article.source?.name ?? "No Source")")
                    Text("Author: \(article.author ?? "No Author")")
                }
                .foregroundColor(Color(UIColor.darkGray))
                
                Text(article.content!)
            }
            .padding()
            
            Spacer()
        }
    }
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(article: TestData.data.articles![2])
    }
}
