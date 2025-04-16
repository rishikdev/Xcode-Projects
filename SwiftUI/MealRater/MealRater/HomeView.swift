//
//  HomeView.swift
//  MealRater
//
//  Created by Rishik Dev on 28/10/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var ratingViewModel: RatingViewModel = RatingViewModel(coreDataHandler: CoreDataHandler.shared)
    
    @State private var showRatingsSheetView: Bool = false
    @State private var isRatingProvided: Bool = false
    @State private var restaurantName: String = ""
    @State private var dishName: String = ""
    @State private var dishRating: Int = 3
    
    var body: some View {
        VStack (spacing: 35) {
            InputFieldView(textValue1: "Restaurant",
                           textFieldValue1: $restaurantName,
                           textValue2: "Dish",
                           textFieldValue2: $dishName)
            
            Text(isRatingProvided ? "Rating: \(dishRating)" : "Rating:")
            
            HStack {
                Button("Rate Meal") {
                    showRatingsSheetView.toggle()
                }
                .tint(.blue)
                .buttonStyle(.bordered)
                .disabled(shouldEnableRateMealButton())
                .sheet(isPresented: $showRatingsSheetView) {
                    RatingsSheetView(showRatingsSheetView: $showRatingsSheetView,
                                     isRatingProvided: $isRatingProvided,
                                     rating: $dishRating)
                }
                
                Spacer()
                
                Button("Save Rating") {
                    saveMeaRating()
                }
                .tint(.green)
                .buttonStyle(.bordered)
                .disabled(shouldEnableSaveRatingButton())
            }
            
            List {
                ForEach(ratingViewModel.ratings, id: \.id) { rating in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(rating.restaurantName)
                                    .fontWeight(.bold)
                                Text(rating.dishName)
                                    .fontWeight(.light)
                            }
                            
                            Spacer()
                            
                            Text(rating.dishRating)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .onDelete(perform: ratingViewModel.deleteRating)
            }
            .listStyle(.inset)
        }
        .padding()
        .onAppear {
            ratingViewModel.fetchRatings()
        }
    }
    
    func shouldEnableRateMealButton() -> Bool {
        return restaurantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        dishName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func shouldEnableSaveRatingButton() -> Bool {
        return !isRatingProvided
    }
    
    func saveMeaRating() {
        let ratingModel = RatingModel(id: UUID(),
                                      restaurantName: restaurantName,
                                      dishName: dishName,
                                      dishRating: "\(dishRating)")
        
        ratingViewModel.saveRating(ratingModel: ratingModel)
        ratingViewModel.fetchRatings()
        
        restaurantName = ""
        dishName = ""
        dishRating = 3
        isRatingProvided = false
    }
}

#Preview {
    HomeView()
}
