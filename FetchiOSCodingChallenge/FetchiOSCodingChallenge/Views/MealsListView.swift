//
//  MealsListView.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 24/04/23.
//

import SwiftUI

struct MealsListView: View {
    @StateObject var mealsListVM = MealsListViewModel(fetchMealsService: FetchMealsService(networkManager: NetworkManager.shared))
    @State var searchText: String = ""
        
    var body: some View {
        NavigationStack {
            VStack {
                if(mealsListVM.isFetchSuccessful) {
                    ScrollView {
                        ForEach(mealsListVM.filteredMeals, id: \.idMeal) { meal in
                            NavigationLink {
                                MealDetailsView(meal: meal)
                            } label: {
                                MealCell(meal: meal)
                            }
                        }
                    }
                } else {
                    ErrorView()
                }
            }
            .navigationTitle("Desserts")
            .onAppear {
                mealsListVM.fetchDesserts()
                searchText = ""
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { searchQuery in
                mealsListVM.searchForMeals(containing: searchQuery)
            }
        }
    }
}

struct MealsListView_Previews: PreviewProvider {
    static var previews: some View {
        MealsListView()
    }
}
