//
//  RestaurantService.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/28/23.
//

import Foundation
import CoreLocation

class RestaurantService: NSObject {
    let ACCESS_KEY = "-kbF9YO7TnshEJfUtvlKE9fA9LtN6NBewt9vHAcPOjKLLTUFFeLks0Swr-czkYB6ZteMpAZOhv7O_hTLL7OiX7O3qzNN_eI-Y3QKtT7HXpE7V98zi5vTEygxx_JIZHYx"
    let BASE_URL = "https://api.yelp.com/v3/businesses/search"
    
    // Singleton to store restaurant results from Yelp API call and favorited restaurants.
    var restaurants: [Restaurant]
    var favoriteRestaurants: [Restaurant]
    // This set will store id's of restaurants, so that we can instantly check if a restaurant is favorited or not
    var favoriteRestaurantsSet: Set<String>
    
    let restaurantsFilePath: URL
    let restaurantsSetFilePath: URL
    
    // shared instance
    static let shared = RestaurantService()
    
    override init() {
        // initialize variables
        restaurants = []
        favoriteRestaurants = []
        favoriteRestaurantsSet = Set<String>()
        
        // load stored data for data persistence
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        restaurantsFilePath = URL(string: "\(documentsDirectory)/restaurants.json")!
        restaurantsSetFilePath = URL(string: "\(documentsDirectory)/restaurantsSet.json")!
        super.init()
        load()
    }
    
    // function that makes an api call based on user inputs such as radius, search query, price, and if the store is open or not
    func getRestaurants(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: Int?, term: String?, price: Int?, is_open: Bool, onSuccess: @escaping ([Restaurant]) -> Void) {
        
        // formulate api url call based on which options were entered
        var url_string = "\(BASE_URL)?latitude=\(String(describing: latitude))&longitude=\(String(describing: longitude))&radius=\(radius ?? 1609)"
        if let term = term {
            url_string += "&term=\(term)"
        }
        if let price = price {
            for price_val in 1...price {
                url_string += "&price=\(price_val)"
            }
        }
        if is_open {
            url_string += "&open_now=\(is_open)"
        }
        url_string += "&limit=50"
        
        // make api call
        if let url = URL(string: url_string) {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("Bearer \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let data = data {
                    // Data that contains our image JSON
                    do {
                        let jsondata = try JSONDecoder().decode(Root.self, from: data)
                        self.restaurants = jsondata.businesses
                    } catch let error {
                        print(error)
                        exit(1)
                    }
                }
                onSuccess(self.restaurants)
            }.resume()
        }
    }
    // returns number of results that are stored in restaurants array
    func numRestaurantResults() -> Int {
        return restaurants.count
    }
    
    // will write the favorited restaurants into a file for future use
    func save() {
        let encoder = JSONEncoder()
        print(restaurantsFilePath)
        do {
            let data = try encoder.encode(favoriteRestaurants)
            let jsonString = String(data: data, encoding: .utf8)!
            try jsonString.write(to: restaurantsFilePath, atomically: true, encoding: .utf8)
        }
        catch {
            print(error)
        }
        // will also save the set.
        print(restaurantsSetFilePath)
        do {
            let data = try encoder.encode(favoriteRestaurantsSet)
            let jsonString = String(data: data, encoding: .utf8)!
            try jsonString.write(to: restaurantsSetFilePath, atomically: true, encoding: .utf8)
        }
        catch {
            print(error)
        }
    }
    
    // will read stored files to load the favorited restaurants into the singleton's favoriteRestaurants array
    func load() {
        // if JSON file exists, load data
        if FileManager.default.fileExists(atPath: restaurantsFilePath.path) {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: restaurantsFilePath)
                let decodedRestaurants = try decoder.decode(Array<Restaurant>.self, from: data)
                favoriteRestaurants = decodedRestaurants
            }
            catch {
                print(error)
            }
            do {
                let data = try Data(contentsOf: restaurantsSetFilePath)
                let decodedRestaurantsSet = try decoder.decode(Set<String>.self, from: data)
                favoriteRestaurantsSet = decodedRestaurantsSet
            }
            catch {
                print(error)
            }

        }
    }
}
