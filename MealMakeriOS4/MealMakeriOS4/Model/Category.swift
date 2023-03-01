//
//  Category.swift
//  MealMakeriOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import Foundation

struct CategoryTopLevelDictionary: Decodable {
    let categories: [GoodFood]
}

struct GoodFood: Decodable {
    private enum CodingKeys: String, CodingKey {
        case categoryID = "idCategory"
        case categoryName = "strCategory"
        case categoryImageURL = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
    
    let categoryID: String
    let categoryName: String
    let categoryImageURL: String
    let description: String
}
