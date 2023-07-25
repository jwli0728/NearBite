//
//  RestaurantDetailViewController.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/29/23.
//

import UIKit
import Kingfisher

class RestaurantDetailViewController: UIViewController {
    
    // IBOutlets to display restaurant information
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    
    var restaurantNumber: Int?
    var displayedRestaurant: Restaurant?
    var isFavorite: Bool = false            //used to determine if favorite button should be filled in or not
    
    override func viewDidLoad() {
        // initialize which restaurant we want to display
        self.displayedRestaurant = RestaurantService.shared.restaurants[self.restaurantNumber!]
        // display restaurant information onto IBOutlets
        setUpPage()
    }
        
    func setUpPage() {
        // determine favorite or not favorite
        self.isFavorite = (RestaurantService.shared.favoriteRestaurantsSet.contains(self.displayedRestaurant!.id)) ? true : false
        
        // Change elements in the View Controller
        // heart symbol (filled in or not)
        if self.isFavorite {
            heartImageView.image = UIImage(systemName: "heart.fill")
        }
        else {
            heartImageView.image = UIImage(systemName: "heart")
        }
        // restaurant info
        restaurantNameLabel.text = displayedRestaurant!.name
        restaurantImage.kf.setImage(with: displayedRestaurant?.image_url)
        restaurantAddressLabel.text = displayedRestaurant?.location.address1
        
        // format the rating
        let nf = NumberFormatter()
        let rate = NSNumber(value: displayedRestaurant?.rating ?? 3)
        nf.numberStyle = .decimal
        let ratingString = nf.string(from:rate)
        restaurantRatingLabel.text = String(format:NSLocalizedString("restaurantRating", comment: ""), ratingString!)
    }
    
    // if the heart is tapped, add/from favoriteRestaurants array in singleton and update heart symbol to be filled/unfilled
    @IBAction func heartDidTapped(_ sender: UIButton) {
        if self.isFavorite {
            // remove from favorite restaurants list/set
            self.isFavorite = false
            heartImageView.image = UIImage(systemName: "heart")
            // remove id from set
            RestaurantService.shared.favoriteRestaurantsSet.remove(self.displayedRestaurant!.id)
            // search for the restaurant to be removed in the list
            if let i = RestaurantService.shared.favoriteRestaurants.firstIndex(of: self.displayedRestaurant!) {
                RestaurantService.shared.favoriteRestaurants.remove(at: i)
            }
        }
        else {
            // add to favorite restaurants list/set
            self.isFavorite = true
            heartImageView.image = UIImage(systemName: "heart.fill")
            // add id to set and list
            RestaurantService.shared.favoriteRestaurantsSet.insert(self.displayedRestaurant!.id)
            RestaurantService.shared.favoriteRestaurants.append(self.displayedRestaurant!)
        }
        // save the favorites array after changes have been made.
        RestaurantService.shared.save()
    }
}
