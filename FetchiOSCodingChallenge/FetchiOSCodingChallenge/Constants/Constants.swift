//
//  Constants.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 24/04/23.
//

import Foundation

enum Constants {
    enum URLs: String {
        case mealDessert = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        case mealInfo = "https://themealdb.com/api/json/v1/1/lookup.php?i={MEAL_ID}"
        case noImage = "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930"
    }
    
    enum Placeholders: String {
        case noImage = "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930"
        case noName = "No Name"
        case noInstructions = "No Instructions"
    }
}
