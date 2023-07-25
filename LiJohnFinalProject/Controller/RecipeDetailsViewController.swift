//
//  RecipeDetailsViewController.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/30/23.
//

import UIKit
import Kingfisher

class RecipeDetailViewController: UIViewController {
    
    // IBOutlets
    
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var glutenFreeLabel: UILabel!
    @IBOutlet weak var vegetarianLabel: UILabel!
    @IBOutlet weak var recipeLinkLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var recipeNumber: Int?
    var displayedRecipe: Recipe?
    var isFavorite: Bool = false
    
    override func viewDidLoad() {
        self.displayedRecipe = RecipeService.shared.recipes[self.recipeNumber!]
        setUpPage()
    }
    
    func setUpPage() {
        // determine favorite or not favorite
        for recipe in RecipeService.shared.favoriteRecipes {
            if displayedRecipe!.id == recipe.id {
                self.isFavorite = true
            }
        }

        // Change elements in the View Controller
        // heart symbol (filled in or not)
        if self.isFavorite {
            heartImageView.image = UIImage(systemName: "heart.fill")
        }
        else {
            heartImageView.image = UIImage(systemName: "heart")
        }
        // restaurant information is put on display by IBOutlets
        recipeNameLabel.text = displayedRecipe!.title
        recipeImage.kf.setImage(with: displayedRecipe?.image)
        // Tells the user if it's vegetarian or not (Using localized string for translation)
        vegetarianLabel.text = (displayedRecipe!.vegetarian) ? NSLocalizedString("isVegetarian", comment: "") : NSLocalizedString("notVegetarian", comment: "")
        // Tells the user if it's gluten-free or not (Using localized string for translation)
        glutenFreeLabel.text = (displayedRecipe!.glutenFree) ? NSLocalizedString("isGlutenFree", comment: "") : NSLocalizedString("notGlutenFree", comment: "")
        // The API summary is in HTML. So we convert the text from HTML styling into regular strings
        summaryLabel.text = displayedRecipe!.summary.htmlToString
        if let link = displayedRecipe!.sourceUrl {
            recipeLinkLabel.text = String(format: NSLocalizedString("recipeLinkAvailable", comment: ""), link.absoluteString)
        }
        else {
            recipeLinkLabel.text = "Recipe Link Not Available"
        }
    }
    
    
    @IBAction func heartDidTapped(_ sender: Any) {
        if self.isFavorite {
            // remove from favorite recipe list
            self.isFavorite = false
            heartImageView.image = UIImage(systemName: "heart")
            // search for the restaurant to be removed in the list
            for (i, recipe) in RecipeService.shared.favoriteRecipes.enumerated() {
                if displayedRecipe!.id == recipe.id {
                    RecipeService.shared.favoriteRecipes.remove(at: i)
                }
            }
        }
        else {
            // add to favorite recipe list
            self.isFavorite = true
            heartImageView.image = UIImage(systemName: "heart.fill")
            // add id to set and list
            RecipeService.shared.favoriteRecipes.append(self.displayedRecipe!)
        }
        RecipeService.shared.save()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewController {
            // tells the web view controller the URL
            print(String(describing: displayedRecipe?.sourceUrl))
            vc.selectedRecipe = displayedRecipe
        }
    }
}

// This allows us to convert a string of HTML (with tags and links) to a regular string
extension Data {
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var htmlToString: String { htmlToAttributedString?.string ?? "" }
}
extension StringProtocol {
    var htmlToAttributedString: NSAttributedString? {
        Data(utf8).htmlToAttributedString
    }
    var htmlToString: String {
        htmlToAttributedString?.string ?? ""
    }
}
