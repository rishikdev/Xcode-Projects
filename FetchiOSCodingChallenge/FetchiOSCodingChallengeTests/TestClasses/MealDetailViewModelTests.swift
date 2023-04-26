//
//  MealDetailViewModelTests.swift
//  FetchiOSCodingChallengeTests
//
//  Created by Rishik Dev on 26/04/23.
//

import XCTest
@testable import FetchiOSCodingChallenge

final class MealDetailViewModelTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var mockFetchMealDetailsService: MockFetchMealDetailsService!
    var mealDetailsVM: MealDetailsViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockNetworkManager = MockNetworkManager()
        mockFetchMealDetailsService = MockFetchMealDetailsService(networkManager: mockNetworkManager)
        mealDetailsVM = MealDetailsViewModel(fetchMealDetailsService: mockFetchMealDetailsService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mealDetailsVM = nil
        mockFetchMealDetailsService = nil
        mockNetworkManager = nil
    }
    
    func testFetchDessertsSuccess() {
        mockNetworkManager.shouldAPICallSucceed = true
        mealDetailsVM.fetchMealDetails(idMeal: "some_valid_id")
        XCTAssertTrue(self.mealDetailsVM.isFetchSuccessful)
    }
    
    func testFetchDessertsFailure() {
        mockNetworkManager.shouldAPICallSucceed = false
        mealDetailsVM.fetchMealDetails(idMeal: "some_invalid_id")
        XCTAssertFalse(self.mealDetailsVM.isFetchSuccessful)
    }
}
