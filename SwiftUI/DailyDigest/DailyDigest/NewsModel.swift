//
//  NewsModel.swift
//  DailyDigest
//
//  Created by Rishik Dev on 13/04/23.
//

struct News: Decodable {
    let status: String
    let totalResults: Int?
    var articles: [Article]?
}

struct Article: Decodable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var isTapped: Bool = false
}

struct Source: Decodable {
    var id: String?
    var name: String?
}
