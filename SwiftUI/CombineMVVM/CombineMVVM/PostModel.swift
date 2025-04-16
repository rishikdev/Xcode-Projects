//
//  PostModel.swift
//  CombineMVVM
//
//  Created by Rishik Dev on 28/06/23.
//

import Foundation

struct Post: Decodable, Identifiable {
    var userId, id: Int
    var title, body: String
}
