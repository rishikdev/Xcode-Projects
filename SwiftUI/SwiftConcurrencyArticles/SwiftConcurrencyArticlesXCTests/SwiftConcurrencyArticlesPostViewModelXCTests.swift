//
//  SwiftConcurrencyArticlesPostViewModelXCTests.swift
//  SwiftConcurrencyArticlesNetworkManagerXCTests
//
//  Created by Rishik Dev on 04/02/2025.
//

import XCTest
@testable import SwiftConcurrencyArticles

final class SwiftConcurrencyArticlesPostViewModelXCTests: XCTestCase {

    var postViewModel: PostViewModel!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        postViewModel = .init(networkManager: MockNetworkManager.shared)
    }

    override func tearDownWithError() throws
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        postViewModel = nil
    }
    
    func testPostViewModel_initialValues() async
    {
        XCTAssertTrue(postViewModel.posts.isEmpty)
        XCTAssertTrue(postViewModel.fetchStatus == .reset)
    }
    
    func testPostViewModel_posts_isNotEmpty() async
    {
        await postViewModel.fetchPosts()
        XCTAssertFalse(postViewModel.posts.isEmpty)
        XCTAssertEqual(postViewModel.fetchStatus, .success)
    }
}
