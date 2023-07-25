//
//  RestaurantLocation.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/26/23.
//

import UIKit


struct RestaurantLocation : Codable{
    // stores the location info of a restaurant
    let address1: String
    let address2: String?
    let address3: String?
    let city: String
    let country: String
    let state: String
    let display_address: [String]
}
