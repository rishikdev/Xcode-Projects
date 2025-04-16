//
//  SwitchGames.swift
//  ApiTest
//
//  Created by Rishik Dev on 23/10/23.
//

import Foundation

//struct SwitchGames: Codable {
//    var switchGames: [SwitchGame]
//}

struct SwitchGame: Codable {
    var id: Int
    var name: String
    var genre: [String]
}

//struct Genre: Codable {
//    var genre: String
//}
