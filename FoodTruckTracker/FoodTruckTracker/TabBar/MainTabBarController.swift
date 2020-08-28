//
//  MainTabBarController.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import CoreLocation
import UIKit

class MainTabBarController: UITabBarController {
    let locationManager = CLLocationManager()
    let apiController = APIController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchViewController {
            searchVC.apiController = apiController
        }
    }

}

extension MainTabBarController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        UserDefaults.lastLatitude = location.coordinate.latitude
        UserDefaults.lastLongitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Failed to get location")
    }
    
}
