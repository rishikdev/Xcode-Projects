//
//  FetchiOSCodingChallengeTests.swift
//  FetchiOSCodingChallengeTests
//
//  Created by Rishik Dev on 24/04/23.
//

import XCTest
@testable import FetchiOSCodingChallenge

final class MealsListViewModelTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var mockFetchMealsService: MockFetchMealsService!
    var mealsListVM: MealsListViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockNetworkManager = MockNetworkManager()
        mealsListVM = MealsListViewModel(fetchMealsService: MockFetchMealsService(networkManager: mockNetworkManager))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mealsListVM = nil
        mockNetworkManager = nil
    }
    
    func testFetchDessertsSuccess() {
        mockNetworkManager.shouldAPICallSucceed = true
        mealsListVM.fetchDesserts()
        XCTAssertEqual(self.mealsListVM.filteredMeals.count, 1)
        XCTAssertTrue(self.mealsListVM.isFetchSuccessful)
    }
    
    func testFetchDessertsFailure() {
        mockNetworkManager.shouldAPICallSucceed = false
        mealsListVM.fetchDesserts()
        XCTAssertEqual(self.mealsListVM.filteredMeals.count, 0)
        XCTAssertFalse(self.mealsListVM.isFetchSuccessful)
    }
}
