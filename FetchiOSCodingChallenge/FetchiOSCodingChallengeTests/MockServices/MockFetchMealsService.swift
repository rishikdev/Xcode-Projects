//
//  MockFetchMealsService.swift
//  FetchiOSCodingChallengeTests
//
//  Created by Rishik Dev on 24/04/23.
//

import Foundation
@testable import FetchiOSCodingChallenge

class MockFetchMealsService: FetchMealsServiceProtocol {
    var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchMeals(urlString: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        networkManager.fetchData(urlString: urlString) { (result: Result<MealModel, Error>) in
            switch(result) {
            case .success(let mealModel):
                completion(.success(mealModel.meals))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
