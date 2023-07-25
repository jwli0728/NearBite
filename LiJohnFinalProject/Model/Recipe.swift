//
//  Recipe.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/30/23.
//

import UIKit

struct Recipe: Codable {
    // Recipe object with the variables we will access later
    let id: Int
    let title: String
    let vegetarian: Bool
    let glutenFree: Bool
    let sourceUrl: URL?
    let image: URL
    let summary: String
}
