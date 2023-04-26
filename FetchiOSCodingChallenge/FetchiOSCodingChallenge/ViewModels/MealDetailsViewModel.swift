//
//  MealDetailsViewModel.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 24/04/23.
//

import Foundation

/// **ViewModel** class for ``MealDetailsView``.
///
/// Properties:
///  - ``fetchMealDetailsService``
///  - ``meal``
///  - ``isFetchSuccessful``
///  - ``ingredients``
///
/// Functions:
///  - ``init(fetchMealDetailsService:)``
///  - ``fetchMealDetails(idMeal:)``
///
class MealDetailsViewModel: ObservableObject {
    var fetchMealDetailsService: FetchMealDetailsServiceProtocol
    @Published var meal: Meal?
    @Published var isFetchSuccessful: Bool = true
    @Published var ingredients = [(key: String, value: String)]()
    
    init(fetchMealDetailsService: FetchMealDetailsServiceProtocol) {
        self.fetchMealDetailsService = fetchMealDetailsService
    }
    
    /// Fetches desserts from a predifined **URL**
    ///
    /// - Calls ``FetchMealDetailsService/fetchMealDetails(urlString:completion:)`` function declared in ``FetchMealDetailsService`` to get an object of type ``Meal``.
    ///
    /// - Parameter idMeal: The **id** of the meal to be fetched.
    ///
    func fetchMealDetails(idMeal: String) {
        let urlString = Constants.URLs.mealInfo.rawValue.replacingOccurrences(of: "{MEAL_ID}", with: idMeal)
        
        fetchMealDetailsService.fetchMealDetails(urlString: urlString) { [weak self] result in
            switch(result) {
            case .success(let meal):
                self?.meal = meal
                for (index, property) in Mirror(reflecting: meal).children.enumerated() {
                    if let label = property.label,
                       let value = property.value as? String {
                        if(label.contains("strIngredient") && !value.isEmpty) {
                            self?.ingredients.append((key: value, value: ""))
                        }
                        
                        if(property.label!.contains("strMeasure") && !value.trimmingCharacters(in: .whitespaces).isEmpty) {
                            self?.ingredients[index - 24].value = value
                        }
                    }
                }
                self?.isFetchSuccessful = true
                
            case .failure(let error):
                print("ERROR: \(error)")
                self?.isFetchSuccessful = false
            }
        }
    }
}
