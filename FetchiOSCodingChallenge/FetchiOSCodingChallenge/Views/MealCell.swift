//
//  MealCell.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 26/04/23.
//

import SwiftUI

struct MealCell: View {
    @Environment(\.colorScheme) private var colourScheme
    var meal: Meal
    
    var body: some View {
        AsyncImage(url: URL(string: meal.strMealThumb!)) { image in
            ZStack(alignment: .bottom) {
                image
                    .resizable()
                    .scaledToFit()
                
                Text(meal.strMeal!)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .foregroundColor(colourScheme == .light ? .black : .white)
            }
        } placeholder: {
            ProgressView()
                .progressViewStyle(.circular)
        }
        .cornerRadius(10)
        .padding()
    }
}

struct MealCell_Previews: PreviewProvider {
    static var previews: some View {
        MealCell(meal: Meal(strMeal: "Apam balik", strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"))
    }
}
