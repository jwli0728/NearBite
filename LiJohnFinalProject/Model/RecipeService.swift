//
//  RecipeService.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/30/23.
//

import UIKit

class RecipeService: NSObject {
    
    
//    let ACCESS_KEY = "fb62847066054c199cc217e5b1b9aa34"
    let ACCESS_KEY = "7674ba4543904f6ea882f93615220051"
    let BASE_URL = "https://api.spoonacular.com/"
    
    // Singleton to store recipe results from Spoonacular API call and favorited recipes.
    var recipe_ids: [RecipeID]
    var recipes: [Recipe]
    var favoriteRecipes: [Recipe]
    let recipesFilePath: URL
    
    // shared instance
    static let shared = RecipeService()
    
    override init() {
        // initialize values
        recipe_ids = []
        recipes = []
        favoriteRecipes = []
        
        // load stored data from previous uses
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        recipesFilePath = URL(string: "\(documentsDirectory)/recipes.json")!
        super.init()
        load()
        
        
    }
    
    // function that makes an api call based on user inputs such as search query, diet, and restricutions. The resulting recipe IDs are stored.
    func getRecipeIDs(query: String?, vegetarian: Bool, gluten_free: Bool, onSuccess: @escaping ([RecipeID]) -> Void) {
        
        //
        var url_string = "\(BASE_URL)recipes/complexSearch?apiKey=\(ACCESS_KEY)"
        if let query = query {
            url_string += "&query=\(query)"
        }
        if vegetarian {
            url_string += "&diet=vegetarian"
        }
        if gluten_free {
            url_string += "&intolerances=gluten"
        }
        url_string += "&number=10"
        
        // make api call
        if let url = URL(string: url_string) {
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let data = data {
                    // Data that contains our recipes JSON
                    do {
                        let jsondata = try JSONDecoder().decode(RecipeRoot.self, from: data)
                        self.recipe_ids = jsondata.results
                    } catch let error {
                        print(error)
                        exit(1)
                    }
                }
                onSuccess(self.recipe_ids)
            }.resume()
        }
    }
    
    // function that makes an api call using stored recipe IDs to get advanced information about each recipe.
    func getRecipes(onSuccess: @escaping ([Recipe]) -> Void) {
        
        var url_string = "\(BASE_URL)recipes/informationBulk?ids="
        for (i, id) in recipe_ids.enumerated() {
            url_string += String(id.id)
            if i != recipe_ids.count - 1 {
                url_string += ","
            }
        }
        url_string += "&apiKey=\(ACCESS_KEY)"
        
        // make api call
        if let url = URL(string: url_string) {
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let data = data {
                    // Data that contains our recipes JSON
                    do {
                        self.recipes = try JSONDecoder().decode(Array<Recipe>.self, from: data)
                    } catch let error {
                        print(error)
                        exit(1)
                    }
                }
                onSuccess(self.recipes)
            }.resume()
        }
    }
    // will write the favorited recipes into a file for future use
    func save() {
        let encoder = JSONEncoder()
         
        print(recipesFilePath)
        do {
            let data = try encoder.encode(favoriteRecipes)
            let jsonString = String(data: data, encoding: .utf8)!
            try jsonString.write(to: recipesFilePath, atomically: true, encoding: .utf8)
        }
        catch {
            print(error)
        }
    }
    
    // will read stored files to load the favorited recipes into the singleton's favoriteRecipes array
    func load() {
        // if JSON file exists, load data
        if FileManager.default.fileExists(atPath: recipesFilePath.path) {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: recipesFilePath)
                let decodedRecipes = try decoder.decode(Array<Recipe>.self, from: data)
                
                favoriteRecipes = decodedRecipes
            }
            catch {
                print(error)
            }
        }
    }
}
