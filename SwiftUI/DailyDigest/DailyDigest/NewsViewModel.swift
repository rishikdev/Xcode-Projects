//
//  NewsViewModel.swift
//  DailyDigest
//
//  Created by Rishik Dev on 13/04/23.
//

import Foundation

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    
    func fetchNews() {
        
    }
    
    func fetchTestNews() {
        self.articles = TestData.data.articles!
    }
    
    func toggleIsTapped(for article: Article) {
        let index = articles.firstIndex { $0.url == article.url }!
        self.articles[index].isTapped.toggle()
        
        /*
        for (index, article) in self.articles.enumerated() {
            if(article.url == tappedArticle.url) {
                self.articles[index].isTapped.toggle()
            } else {
                self.articles[index].isTapped = false
            }
        }
         */
    }
}
