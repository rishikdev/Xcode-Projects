//
//  MealsListViewModel.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 24/04/23.
//

import Foundation

/// **ViewModel** class for ``MealsListView``
///
/// Properties:
///  - ``fetchMealsService``
///  - ``filteredMeals``
///  - ``isFetchSuccessful``
///
/// Functions:
///  - ``init(fetchMealsService:)``
///  - ``fetchDesserts()``
///  - ``searchForMeals(containing:)``
///
class MealsListViewModel: ObservableObject {
    var fetchMealsService: FetchMealsServiceProtocol
    private var meals = [Meal]()
    @Published var filteredMeals = [Meal]()
    @Published var isFetchSuccessful: Bool = true
    
    init(fetchMealsService: FetchMealsServiceProtocol) {
        self.fetchMealsService = fetchMealsService
    }
    
    /// Fetches desserts from a predifined **URL**
    ///
    /// - Calls ``FetchMealsService/fetchMeals(urlString:completion:)`` function declared in ``FetchMealsService`` to get an array of ``Meal`` objects.
    ///
    func fetchDesserts() {
        fetchMealsService.fetchMeals(urlString: Constants.URLs.mealDessert.rawValue) { [weak self] result in
            switch(result) {
            case .success(let meals):
                // Filtering out meals with empty idMeal, strMeal, or strMealThumb.
                let filteredObtainedMeals = (meals.filter { $0.idMeal != nil || $0.strMeal != nil || $0.strMealThumb != nil }.sorted { $0.strMeal ?? "" < $1.strMeal ?? "" })
                self?.meals = filteredObtainedMeals
                self?.filteredMeals = filteredObtainedMeals
                self?.isFetchSuccessful = true
            
            case .failure(let error):
                print("ERROR: \(error)")
                self?.isFetchSuccessful = false
            }
        }
    }
    
    /// Searches for a particular meal or meals matching the provided `searchText`.
    ///
    /// - Parameter searchText: The name of the meal to be searched
    ///
    func searchForMeals(containing searchText: String) {
        let searchQuery = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if(!searchQuery.isEmpty) {
            self.filteredMeals = self.meals.filter { $0.strMeal!.trimmingCharacters(in: .whitespaces).lowercased().contains(searchQuery) }
        } else {
            self.filteredMeals = self.meals
        }
    }
}
