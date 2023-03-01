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
    }
    
    // MARK: - Properties
    var category: GoodFood?
    var goodMealArray: [GoodMeals] = []

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    

  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
