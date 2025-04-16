//
//  SwiftConcurrencyArticlesNetworkManagerSTTests.swift
//  SwiftConcurrencyArticlesSTTests
//
//  Created by Rishik Dev on 04/02/2025.
//

import Testing
import Foundation
@testable import SwiftConcurrencyArticles

struct SwiftConcurrencyArticlesNetworkManagerSTTests
{

    @Test func NetworkManager_fetchPosts_success() async throws
    {
        let posts = try await MockNetworkManager.shared.fetchPosts(from: "www.apple.com")
        #expect(posts.count > 0)
    }
    
    @Test func NetworkManager_fetchPosts_failure() async throws
    {
        await #expect(throws: URLError.self)
        {
            try await MockNetworkManager.shared.fetchPosts(from: "")
        }
    }
}
