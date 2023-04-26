//
//  MealModel.swift
//  FetchiOSCodingChallenge
//
//  Created by Rishik Dev on 24/04/23.
//

import Foundation

struct MealModel: Decodable {
    var meals: [Meal]
}

struct Meal: Decodable {
    var strMeal: String?
    var strMealThumb: String?
    var idMeal: String?
    var strInstructions: String?
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    var strMeasure1: String?
    var strMeasure2: String?
    var strMeasure3: String?
    var strMeasure4: String?
    var strMeasure5: String?
    var strMeasure6: String?
    var strMeasure7: String?
    var strMeasure8: String?
    var strMeasure9: String?
    var strMeasure10: String?
    var strMeasure11: String?
    var strMeasure12: String?
    var strMeasure13: String?
    var strMeasure14: String?
    var strMeasure15: String?
    var strMeasure16: String?
    var strMeasure17: String?
    var strMeasure18: String?
    var strMeasure19: String?
    var strMeasure20: String?
}

struct DummyMeal {
    static func getDummyMealForTesting() -> MealModel {
        let dummyMeal = Meal(strMeal: "Apam balik",
                                    strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                                    idMeal: "53049",
                                    strInstructions: "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.",
                                    strIngredient1: "Milk",
                                    strIngredient2: "Oil",
                                    strIngredient3: "Eggs",
                                    strIngredient4: "Flour",
                                    strIngredient5: "Baking Powder",
                                    strIngredient6: "Salt",
                                    strIngredient7: "Unsalted Butter",
                                    strIngredient8: "Sugar",
                                    strIngredient9: "Peanut Butter",
                                    strIngredient10: "",
                                    strIngredient11: "",
                                    strIngredient12: "",
                                    strIngredient13: "",
                                    strIngredient14: "",
                                    strIngredient15: "",
                                    strIngredient16: "",
                                    strIngredient17: "",
                                    strIngredient18: "",
                                    strIngredient19: "",
                                    strIngredient20: "",
                                    strMeasure1: "200ml",
                                    strMeasure2: "60ml",
                                    strMeasure3: "2",
                                    strMeasure4: "1600g",
                                    strMeasure5: "3 tsp",
                                    strMeasure6: "1/2 tsp",
                                    strMeasure7: "25g",
                                    strMeasure8: "45g",
                                    strMeasure9: "3 tbs",
                                    strMeasure10: "",
                                    strMeasure11: "",
                                    strMeasure12: "",
                                    strMeasure13: "",
                                    strMeasure14: "",
                                    strMeasure15: "",
                                    strMeasure16: "",
                                    strMeasure17: "",
                                    strMeasure18: "",
                                    strMeasure19: "",
                                    strMeasure20: "")
        
        return MealModel(meals: [dummyMeal])
    }
}
