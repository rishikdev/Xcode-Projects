//
//  MockNetworkManager.swift
//  SwiftConcurrencyArticlesNetworkManagerSTTests
//
//  Created by Rishik Dev on 04/02/2025.
//

import Foundation
@testable import SwiftConcurrencyArticles

actor MockNetworkManager: NetworkManagerProtocol
{
    static let shared = MockNetworkManager()
    private init() { }
    
    func fetchPosts(from urlString: String) async throws -> [PostModel]
    {
        guard let _ = URL(string: urlString) else { throw URLError(.badURL) }
        
        return [PostModel(userId: 1, id: 1, title: "Post Title", body: "Post Body")]
    }
}
