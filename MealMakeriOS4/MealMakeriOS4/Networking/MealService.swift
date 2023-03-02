//
//  MealService.swift
//  MealMakeriOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import Foundation
import UIKit

struct MealService {
    
    static func fetchAllCategories(completion: @escaping (Result<[GoodFood], NetworkError>) -> Void) {
        guard let finalURL = URL(string: Constants.MealService.allCategoriesBaseURL) else {completion(.failure(.invalidURL)) ; return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            
            guard let data = data else { completion(.failure(.noData)); return}
            
            do {
                let topLevel = try JSONDecoder().decode(CategoryTopLevelDictionary.self, from: data)
                completion(.success(topLevel.categories))
            } catch {
                completion(.failure(.unableToDecode)) ; return
            }
        }.resume()
    }
    
    static func fetchMealsInCategory(forCategory category: GoodFood, completion: @escaping (Result<[GoodMeals], NetworkError>) -> Void) {
        
        guard let baseURL = URL(string: Constants.MealService.mealsInCategoriesBaseURL) else {completion(.failure(.invalidURL)); return}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let categoryQueryItem = URLQueryItem(name: Constants.MealService.categoryQueryKey, value: category.categoryName)
        urlComponents?.queryItems = [categoryQueryItem]
        guard let finalURL = urlComponents?.url else {completion(.failure(.invalidURL)) ; return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard let data = data else {completion(.failure(.noData)); return}
            do {
                let topLevel = try JSONDecoder().decode(MealTopLevelDictionary.self, from: data)
                completion(.success(topLevel.meals))
                
            } catch {
                completion(.failure(.unableToDecode))
                return
            }
        }.resume()
    }
    
    static func fetchRecipe(forMeal meal: GoodMeals, completion: @escaping (Result<Recipe, NetworkError>) -> Void) {
        
        guard let baseURL = URL(string: Constants.MealService.fetchRecipeBaseURL) else { completion(.failure(.invalidURL)); return}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let recipeQueryItem = URLQueryItem(name: Constants.MealService.recipeQueryKey, value: meal.mealID)
        urlComponents?.queryItems = [recipeQueryItem]
        
        guard let finalURL = urlComponents?.url else {completion(.failure(.invalidURL)); return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard let data = data else {completion(.failure(.noData)); return}
            
            do {
                let topLevel = try JSONDecoder().decode(RecipeTopLevelDictionary.self, from: data)
                if let recipe = topLevel.meals.first {
                    completion(.success(recipe))
                } else {
                    completion(.failure(.emptyArray))
                }
            } catch {
                completion(.failure(.unableToDecode))
                return
            }
        }.resume()
    }
    
    static func fetchImage(for item: String?, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let item = item else { completion(.success(UIImage(named: "IMG_1654")!)); return }
        guard let finalURL = URL(string: item) else {completion(.failure(.invalidURL)); return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                      completion(.failure(.invalidStatusCode))
                return
                  }
            
            guard let data = data, !data.isEmpty else {completion(.failure(.noData)); return}
            
            guard let image = UIImage(data: data) else {completion(.failure(.unableToDecode)); return}
            completion(.success(image))
        }.resume()
    }
}
