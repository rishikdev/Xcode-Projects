//
//  FetchMealsService.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 24/04/23.
//

import Foundation

/// Protocol for ``FetchMealsService`` class.
///
/// Properties:
///  - ``networkManager``
///
///  Functions:
///   - ``fetchMeals(urlString:completion:)``
///
protocol FetchMealsServiceProtocol {
    /// An instance of `NetworkManager`
    var networkManager: NetworkManagerProtocol { get set }
    
    /// Fetches an array of meals.
    ///
    /// - This function calls the `fetchData(urlString:completion)` function declared in `NetworkManager` to fetch an array of `Meal` objects.
    /// - The parameter `completion` has one argument:
    ///     1. `Result`: If the fetch was successful, it contains an array of ``Meal`` objects. Otherwise, it contains error message.
    ///
    /// - Parameters:
    ///   - urlString: The **URL** from which data needs to be fetched.
    ///   - completion: An escaping closure with one argument.
    ///   
    func fetchMeals(urlString: String, completion: @escaping (Result<[Meal], Error>) -> Void)
}

class FetchMealsService: FetchMealsServiceProtocol {
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
