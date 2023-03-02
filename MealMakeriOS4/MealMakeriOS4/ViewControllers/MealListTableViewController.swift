//
//  MealListTableViewController.swift
//  MealMakeriOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import UIKit

class MealListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMealsInCategory()
        setUpActivityIndicator()
    }
    
    // MARK: - Properties
    var category: GoodFood?
    var goodMealArray: [GoodMeals] = []
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Functions
    func fetchMealsInCategory() {
        guard let category = category else {return}
        MealService.fetchMealsInCategory(forCategory: category) { [weak self] result in
            switch result {
                
            case .success(let meals):
                self?.goodMealArray = meals
                self?.stopAnimatingAndReloadData()
                
            case .failure(let error):
                print(error.errorDescription ?? "Error")
            }
        }
    }
    
    func setUpActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }

    func stopAnimatingAndReloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goodMealArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)

        let meal = goodMealArray[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = meal.mealName
        config.secondaryText = meal.mealID
        cell.contentConfiguration = config

        return cell
    }
    

  

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? RecipeViewController else {return}
            let meal = goodMealArray[indexPath.row]
            destinationVC.meal = meal
        }
    }
    

}
