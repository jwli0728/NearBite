//
//  Root.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/28/23.
//

import UIKit

struct Root : Decodable {
    // Root structure to decode the Yelp API call
    let businesses: [Restaurant]
}
