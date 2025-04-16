//
//  PostModel.swift
//  SwiftConcurrencyArticles
//
//  Created by Rishik Dev on 03/02/2025.
//

import Foundation

struct PostModel: Decodable, Identifiable
{
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
