//
//  TruckListTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/31/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import CoreLocation
import UIKit

class TruckListTableViewCell: UITableViewCell {
    
    var truck: Truck? { didSet { updateViews() } }
    var truckImage: UIImage? {
        set { truckImageView.image = newValue }
        get { truckImageView.image }
    }
    
    @IBOutlet private var truckImageView: UIImageView!
    @IBOutlet private var truckNameLabel: UILabel!
    @IBOutlet private var cuisineTypeLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    @IBOutlet private var starRating: StarRatingView!
    
    private func updateViews() {
        guard let truck = truck else { return }
        truckNameLabel.text = truck.truckName
        cuisineTypeLabel.text = truck.cuisineType
        starRating.value = Int(truck.customerRatingAvg)
        updateDistanceLabel(with: truck)
    }
    
    private func updateDistanceLabel(with truck: Truck) {
        guard let lat = UserDefaults.lastLatitude,
            let lon = UserDefaults.lastLongitude else {
                return
        }
        
        let userLocation = CLLocation(latitude: lat, longitude: lon)
        
        let truckLocation = CLLocation(latitude: truck.coordinate.latitude,
                                       longitude: truck.coordinate.longitude)
        
        let distance = userLocation.distance(from: truckLocation)
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        distanceLabel.text = meters.string
    }

    override func prepareForReuse() {
        truckImage = nil
    }
}
