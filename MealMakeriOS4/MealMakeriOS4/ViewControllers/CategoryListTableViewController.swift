//
//  CategoryListTableViewController.swift
//  MealMakeriOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import UIKit

class CategoryListTableViewController: UITableViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllCategories()
    }
    
    // MARK: - Properties
    var goodFoodArray: [GoodFood] = []
    
    // MARK: - Functions
    func fetchAllCategories() {
        MealService.fetchAllCategories { [weak self] result in
            switch result {
                
            case .success(let goodFood):
                self?.goodFoodArray = goodFood
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.errorDescription ?? "Chase Hill")
            }
        }
    }
    
    func configureCell(cell: UITableViewCell, category: GoodFood) {
        var config = cell.defaultContentConfiguration()
        config.text = category.categoryName
        config.textProperties.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        config.secondaryText = category.description
        config.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14, weight: .light)
        config.secondaryTextProperties.numberOfLines = 3
        cell.contentConfiguration = config
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goodFoodArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        let category = goodFoodArray[indexPath.row]
        configureCell(cell: cell, category: category)
        return cell
    }
    

    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMealVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? MealListTableViewController else {return}
            let category = goodFoodArray[indexPath.row]
            destinationVC.category = category
        }
            
    }
    

}
