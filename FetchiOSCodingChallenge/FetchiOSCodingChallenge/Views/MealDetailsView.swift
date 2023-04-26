//
//  MealDetailView.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 24/04/23.
//

import SwiftUI

struct MealDetailsView: View {
    @StateObject var mealDetailsVM = MealDetailsViewModel(fetchMealDetailsService: FetchMealDetailsService(networkManager: NetworkManager.shared))
    
    var meal: Meal
    
    var body: some View {
        VStack {
            if(mealDetailsVM.isFetchSuccessful) {
                ScrollView {
                    VStack {
                        AsyncImage(url: URL(string: meal.strMealThumb ?? Constants.Placeholders.noImage.rawValue)) { image in
                            ZStack(alignment: .bottom) {
                                image
                                    .resizable()
                                    .scaledToFit()
                                
                                Text(meal.strMeal ?? Constants.Placeholders.noName.rawValue)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.thinMaterial)
                            }
                            
                        } placeholder: {
                            Image(systemName: "photo")
                        }
                        .cornerRadius(10)
                        
                        DisclosureGroup("Instructions") {
                            Divider()
                            Text(mealDetailsVM.meal?.strInstructions ?? Constants.Placeholders.noInstructions.rawValue)
                        }
                        .padding()
                        .background(Color(uiColor: .systemGray6))
                        .cornerRadius(10)
                        
                        DisclosureGroup("Ingredients") {
                            Divider()
                            ForEach(mealDetailsVM.ingredients.indices, id: \.self) { i in
                                HStack {
                                    Text(mealDetailsVM.ingredients[i].key)
                                    Spacer()
                                    Text(mealDetailsVM.ingredients[i].value)
                                }
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .systemGray6))
                        .cornerRadius(10)
                    }
                }
            } else {
                ErrorView()
            }
            
        }
        .navigationTitle(meal.strMeal ?? Constants.Placeholders.noName.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onAppear {
            mealDetailsVM.fetchMealDetails(idMeal: meal.idMeal!)
        }
    }
}

struct MealDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MealDetailsView(meal: DummyMeal.getDummyMealForTesting().meals[0])
        }
    }
}
