//
//  FavoritesViewController.swift
//  LiJohnFinalProject
//
//  Created by John Li on 5/1/23.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 2 Section table view
    @IBOutlet weak var favoritesTableView: UITableView!
    
    // array to store section header names (localized strings)
    let sectionHeaders = [NSLocalizedString("Restaurants", comment: ""), NSLocalizedString("Recipes", comment: "")]
    var numRows = [RestaurantService.shared.favoriteRestaurants.count, RecipeService.shared.favoriteRecipes.count]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.delegate = self
        favoritesTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        favoritesTableView.reloadData()
        // update rows needed
        numRows = [RestaurantService.shared.favoriteRestaurants.count, RecipeService.shared.favoriteRecipes.count]
    }
    
    // How many sections to render
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionHeaders.count
    }
    // For a given section, what is the name
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    // For a given section, how many cells to render?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows[section]
    }
    // For a given index path (e.g. section, row) what is the cell to return
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell")
        if indexPath.section == 0 {
            cell?.textLabel?.text = RestaurantService.shared.favoriteRestaurants[indexPath.row].name
        }
        else {
            cell?.textLabel?.text = RecipeService.shared.favoriteRecipes[indexPath.row].title
        }
        return cell ?? UITableViewCell()
    }
}
