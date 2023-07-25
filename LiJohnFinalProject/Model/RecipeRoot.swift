//
//  RecipeRoot.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/30/23.
//

import UIKit

struct RecipeRoot: Decodable {
    // Root structure to decode the Spoonacular API call
    let results: [RecipeID]
}
