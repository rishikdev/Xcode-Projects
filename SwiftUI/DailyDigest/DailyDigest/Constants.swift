//
//  Constants.swift
//  DailyDigest
//
//  Created by Rishik Dev on 12/04/23.
//

enum Constants {
    enum APIKeys: String {
        case news = "9c2adcfda78940db883d169f4270e304"
    }
    
    enum URLs: String {
        case defaultNews = "https://newsapi.org/v2/everything?apiKey={INSERT_API_KEY}"
        case defaultImage = "https://commons.wikimedia.org/wiki/File:No_Image_Available.jpg"
    }
}
