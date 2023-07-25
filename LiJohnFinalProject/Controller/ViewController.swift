//
//  ViewController.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/22/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // IBOutlets to retrieve user inputs
    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var priceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var isOpenSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // reset values
        setDefaultValues()
    }

    // reset values in IBOutlets to blank/default values
    func setDefaultValues() {
        // TODO
        termTextField.text = ""
        distanceTextField.text = ""
        priceSegmentedControl.selectedSegmentIndex = 1
        isOpenSwitch.isOn = true
    }
    
    // method executes whenever a segue transition is about to occur
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let restResultsVC = segue.destination as? RestaurantResultsViewController {
            // closures retain the context in which they are called in. As such, they will be able to access IBOutlets in this view controller for the destination view controller.
            restResultsVC.onComplete = {
                // make API call.
                RestaurantService.shared.getRestaurants(latitude: LocationService.shared.latitude ?? CLLocationDegrees(34.021334), longitude: LocationService.shared.longitude ?? CLLocationDegrees(-118.284867), radius: Int(self.distanceTextField.text!) ?? 1000, term: self.termTextField.text ?? "", price: self.priceSegmentedControl.selectedSegmentIndex + 1, is_open: self.isOpenSwitch.isOn) {_ in
                    // On success will refresh the tableview once api call is completed
                    DispatchQueue.main.async {
                        restResultsVC.restaurantResultsTableView.reloadData()
                    }
                }
            }
        }
    }
}

