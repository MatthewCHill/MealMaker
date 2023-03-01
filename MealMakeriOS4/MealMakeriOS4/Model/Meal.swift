//
//  Meal.swift
//  MealMakeriOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import Foundation

struct MealTopLevelDictionary: Decodable {
    let meals: [GoodMeals]
}

struct GoodMeals: Decodable {
    private enum CodingKeys: String, CodingKey {
        case mealName = "strMeal"
        case mealImageURL = "strMealThumb"
        case mealID = "idMeal"
    }
    
    let mealName: String
    let mealImageURL: String
    let mealID: String
}
