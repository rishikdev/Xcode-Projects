//
//  SwiftConcurrencyArticlesPostViewModelTests.swift
//  SwiftConcurrencyArticlesSTTests
//
//  Created by Rishik Dev on 04/02/2025.
//

import Testing
@testable import SwiftConcurrencyArticles

struct SwiftConcurrencyArticlesPostViewModelSTTests {

    @Test func postViewModel_initialValues() async throws {
        let postVM: PostViewModel = .init(networkManager: MockNetworkManager.shared)
        #expect(postVM.fetchStatus == .reset)
        #expect(postVM.posts.isEmpty)
    }
    
    @Test func postViewModel_fetchPosts() async throws {
        let postVM: PostViewModel = .init(networkManager: MockNetworkManager.shared)
        await postVM.fetchPosts()
        #expect(postVM.fetchStatus == .success)
        #expect(!postVM.posts.isEmpty)
    }

}
