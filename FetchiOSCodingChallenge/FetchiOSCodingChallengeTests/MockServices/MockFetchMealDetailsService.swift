//
//  MockFetchMealDetailsService.swift
//  FetchiOSCodingChallengeTests
//
//  Created by Rishik Dev on 26/04/23.
//

import Foundation
@testable import FetchiOSCodingChallenge

class MockFetchMealDetailsService: FetchMealDetailsServiceProtocol {
    var networkManager: FetchiOSCodingChallenge.NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchMealDetails(urlString: String, completion: @escaping (Result<FetchiOSCodingChallenge.Meal, Error>) -> Void) {
        networkManager.fetchData(urlString: urlString) { (result: Result<MealModel, Error>) in
            switch(result) {
            case .success(let mealModel):
                completion(.success(mealModel.meals[0]))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
