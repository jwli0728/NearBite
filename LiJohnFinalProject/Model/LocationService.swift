//
//  LocationService.swift
//  LiJohnFinalProject
//
//  Created by John Li on 4/24/23.
//

import UIKit
import CoreLocation


class LocationService : NSObject, CLLocationManagerDelegate {
    
    // shared instance
    static let shared = LocationService()
    
    // singleton that is in charge of user location.
    let locationManager : CLLocationManager
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if locationManager.authorizationStatus == .authorizedAlways ||  locationManager.authorizationStatus == .authorizedWhenInUse{
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    // changes latitude and longitude variables whenever location gets updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
    }
   
}
