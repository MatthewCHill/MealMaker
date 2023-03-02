//
//  RecipeViewController.swift
//  MealMakeriOS4
//
//  Created by Matthew Hill on 3/2/23.
//

import UIKit

class RecipeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeAreaLabel: UILabel!
    @IBOutlet weak var recipeYoutubeLinkLabel: UILabel!
    @IBOutlet weak var recipeInstructionsLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsTableView.dataSource = self
        fetchRecipe()
    }
    
    // MARK: - Properties
    var meal: GoodMeals?
    var recipe: Recipe?
    
    // MARK: - Functions
    
    func fetchRecipe() {
        guard let meal = meal else { return }
        MealService.fetchRecipe(forMeal: meal) { [weak self] result in
            switch result {
                
            case .success(let recipe):
                self?.recipe = recipe
                DispatchQueue.main.async {
                    self?.updateUI(withRecipe: recipe)
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown Error")
            }
        }
    }
    
    func updateUI(withRecipe recipe: Recipe) {
        recipeNameLabel.text = recipe.mealName
        recipeAreaLabel.text = recipe.areaOfOrigin
        recipeYoutubeLinkLabel.text = recipe.youtubeLink
        recipeInstructionsLabel.text = recipe.instructions
        ingredientsTableView.reloadData()
        fetchRecipeImage()
    }
    
    func fetchRecipeImage() {
        MealService.fetchImage(for: recipe?.imageURL) { [weak self] result in
            switch result {
                
            case .success(let image):
                DispatchQueue.main.async {
                    self?.recipeImageView.image = image
                }
            case .failure(let error):
                print(error.errorDescription ?? "Uknown Error")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInstructionsVC" {
            guard let recipe = recipe,
                  let destinationVC = segue.destination as? InstructionsViewController else {return}
            destinationVC.instructions = recipe.instructions
        }
    } // end of class
}
// MARK: - Extension
extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        guard let ingredient = recipe?.ingredients[indexPath.row] else {return UITableViewCell()}
        
        var config = cell.defaultContentConfiguration()
        config.text = ingredient.name
        config.secondaryText = ingredient.measurement
        cell.contentConfiguration = config
        
        return cell
    }
}
