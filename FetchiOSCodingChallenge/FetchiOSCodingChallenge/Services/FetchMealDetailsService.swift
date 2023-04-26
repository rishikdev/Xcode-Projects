//
//  FetchMealDetailsService.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 26/04/23.
//

import Foundation

/// Protocol for ``FetchMealDetailsService`` class.
///
/// Properties:
///  - ``networkManager``
///
///  Functions;
///   - ``fetchMealDetails(urlString:completion:)``
///   
protocol FetchMealDetailsServiceProtocol {
    /// An instance of `NetworkManager`
    var networkManager: NetworkManagerProtocol { get set }
    
    /// Fetches an array of meals.
    ///
    /// - This function calls the `fetchData(urlString:completion)` function declared in `NetworkManager` to fetch an object of type ``MealModel``.
    /// - The parameter `completion` has one argument:
    ///     1. `Result`: If the fetch was successful, it contains an array of ``Meal`` objects. Otherwise, it contains error message.
    ///
    /// - Parameters:
    ///   - urlString: The **URL** from which data needs to be fetched.
    ///   - completion: An escaping closure with one argument.
    ///
    func fetchMealDetails(urlString: String, completion: @escaping (Result<Meal, Error>) -> Void)
}


class FetchMealDetailsService: FetchMealDetailsServiceProtocol {
    var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchMealDetails(urlString: String, completion: @escaping (Result<Meal, Error>) -> Void) {
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
