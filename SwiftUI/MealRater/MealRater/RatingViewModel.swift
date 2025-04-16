//
//  RatingViewModel.swift
//  MealRater
//
//  Created by Rishik Dev on 11/11/24.
//

import Foundation

class RatingViewModel: ObservableObject {
    @Published var ratings: [RatingModel] = []
    
    let coreDataHandler: CoreDataHandler
    
    init(coreDataHandler: CoreDataHandler) {
        self.coreDataHandler = coreDataHandler
    }
    
    func fetchRatings() {
        let ratings = coreDataHandler.fetchData()
        var _ratings: [RatingModel] = []
        
        for rating in ratings {
            let id = rating.id ?? UUID()
            let restaurantName = rating.restaurantName ?? "Not Provided"
            let mealName = rating.dishName ?? "Not Provided"
            let mealRating = rating.dishRating ?? "Not Provided"
            
            let ratingModel = RatingModel(id: id, restaurantName: restaurantName, dishName: mealName, dishRating: mealRating)
            
            _ratings.append(ratingModel)
        }
        
        self.ratings = _ratings
    }
    
    func saveRating(ratingModel: RatingModel) {
        coreDataHandler.saveData(ratingModel: ratingModel)
    }
    
    func deleteRating(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let ratingModel = ratings[index]
        
        coreDataHandler.deleteRating(ratingModel: ratingModel)
    }
}
