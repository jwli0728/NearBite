//
//  RestaurantResultsViewController.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/29/23.
//

import UIKit
import Kingfisher

class RestaurantResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var restaurantResultsTableView: UITableView!
    var onComplete: (() -> Void)?
    var chosenIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // calls get restaurants
        // uses reload tableview as the oncomplete closure
        self.onComplete?()
        
        restaurantResultsTableView.delegate = self

    }
    // How many sections to render
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // For a given section, how many cells to render?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return RestaurantService.shared.numRestaurantResults()
    }
    // For a given index path (e.g. section, row) what is the cell to return
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = restaurantResultsTableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
        cell.textLabel?.text = RestaurantService.shared.restaurants[indexPath.row].name
        
        return cell
    }
    
    // delegate method for when a restaurant gets clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenIndex = indexPath.row
        performSegue(withIdentifier: "toRestaurantDetails", sender: self)
    }
    // send info to next vc about which restaurant to display
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RestaurantDetailViewController {
            vc.restaurantNumber = chosenIndex
        }
    }
}
