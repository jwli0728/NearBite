//
//  Restaurant.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/26/23.
//

import UIKit

struct Restaurant : Codable, Equatable, Hashable {
    // restaurant object with the variables we will access later
    let id: String
    let name: String
    let image_url: URL
    let is_closed: Bool
    let rating: Float
    let location: RestaurantLocation
    
    // These are so that we can store restaurants into a set.
    // equatable
    static func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id
    }
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
