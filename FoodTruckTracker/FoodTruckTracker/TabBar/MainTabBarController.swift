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
    
    private let loginNav: UINavigationController = UIStoryboard(name: "Login", bundle: .main).instantiateInitialViewController()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
    
        guard let nav = children[0] as? UINavigationController,
            let searchVC = nav.viewControllers.first as? SearchViewController else {
            fatalError("Check main storyboard for \(SearchViewController.self)")
        }
        searchVC.apiController = apiController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(loginNav, animated: true)
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
