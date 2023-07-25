//
//  RecipeResultsViewController.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/30/23.
//

import UIKit

class RecipeResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recipeResultsTableView: UITableView!
    var onComplete: (() -> Void)?
    
    var chosenIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // gets recipe information
        // uses reload tableview as the oncomplete closure
        self.onComplete?()
        
        recipeResultsTableView.delegate = self
    }
    // How many sections to render
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // For a given section, how many cells to render?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeService.shared.recipes.count
    }
    // For a given index path (e.g. section, row) what is the cell to return
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeResultsTableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        cell.textLabel?.text = RecipeService.shared.recipes[indexPath.row].title
        return cell
    }
    
    // delegate method for when a recipe gets clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenIndex = indexPath.row
        performSegue(withIdentifier: "toRecipeDetails", sender: self)
    }
    // send info to next vc about which recipe to display
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RecipeDetailViewController {
            vc.recipeNumber = chosenIndex
        }
    }
}
