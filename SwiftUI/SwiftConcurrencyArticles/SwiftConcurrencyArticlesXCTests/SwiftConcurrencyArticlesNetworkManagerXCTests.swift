//
//  SwiftConcurrencyArticlesNetworkManagerXCTests.swift
//  SwiftConcurrencyArticlesXCTests
//
//  Created by Rishik Dev on 04/02/2025.
//

import XCTest
@testable import SwiftConcurrencyArticles

final class SwiftConcurrencyArticlesNetworkManagerXCTests: XCTestCase
{
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNetworkManager_fetchPosts_success() async throws
    {
        let posts = try await MockNetworkManager.shared.fetchPosts(from: "www.apple.com")
        XCTAssertEqual(posts.count, 1)
    }
    
    func testNetworkManager_fetchPosts_failure() async throws
    {
        do
        {
            let _ = try await MockNetworkManager.shared.fetchPosts(from: "")
            XCTFail("Should not provide valid posts for invalid url")
        }
        
        catch let error as URLError
        {
            XCTAssertEqual(error.code, .badURL)
        }
    }
}
