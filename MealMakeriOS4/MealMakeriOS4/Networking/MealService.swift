//
//  MealService.swift
//  MealMakeriOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import Foundation

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
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let categoryQueryItem = URLQueryItem(name: Constants.MealService.categoryQueryKey, value: category.categoryName)
        components?.queryItems = [categoryQueryItem]
        guard let finalURL = components?.url else {completion(.failure(.invalidURL)) ; return}
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
}
