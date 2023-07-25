//
//  RecipeSearchViewController.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/30/23.
//

import UIKit

class RecipeSearchViewController: UIViewController {
    
    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var vegetarianSwitch: UISwitch!
    @IBOutlet weak var glutenFreeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultValues()
    }
    func setDefaultValues() {
        // clears search fields and sets switches to OFF
        termTextField.text = ""
        vegetarianSwitch.isOn = false
        glutenFreeSwitch.isOn = false
    }
    // method executes whenever a segue transition is about to occur
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipeResultsVC = segue.destination as? RecipeResultsViewController {
            recipeResultsVC.onComplete = {
                // finds recipes based on user's input and takes their IDs
                RecipeService.shared.getRecipeIDs(query: self.termTextField.text ?? "", vegetarian: self.vegetarianSwitch.isOn, gluten_free: self.glutenFreeSwitch.isOn) {_ in
                    // Uses those IDs to make a second API call to get indepth information on those recipes
                    RecipeService.shared.getRecipes() {_ in
                        // Reloads the table view
                        DispatchQueue.main.async {
                            recipeResultsVC.recipeResultsTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
